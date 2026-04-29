module ForwardingUnit (
    input  [4:0] idex_rs1, // Registrador 1 no ID/EX
    input  [4:0] idex_rs2, // Registrador 2 no ID/EX
    input  [4:0] exmem_rd, // Registrador destino no EX/MEM
    input  [4:0] memwb_rd, // Registrador destino no MEM/WB

    input  [6:0] exmem_op, // Operação no EX/MEM
    input  [6:0] memwb_op, // Operação no MEM/WB

    output reg [1:0] forwardA,
    output reg [1:0] forwardB
);

    // O controle aqui é diferente da tabela do slide.
    localparam NO_FORWARD  = 2'b00;
    localparam FROM_MEM    = 2'b01;
    localparam FROM_WB_ALU = 2'b10;
    localparam FROM_WB_LD  = 2'b11;

    localparam LW    = 7'b000_0011;
    localparam ALUop = 7'b001_0011;

    initial begin
      forwardA = NO_FORWARD;
      forwardB = NO_FORWARD;
    end

    always @(*) begin
        forwardA = NO_FORWARD;
        forwardB = NO_FORWARD;

        
        // Forward A
        //================================================
        // Conferimos se o registrador 1 é usado (não nulo)
        if (idex_rs1 != 5'd0) begin
            // O if precisa checar se:
            //  1_ .RegWrite: A instrução que encaminha escreve em registrador
            //  2_ O registrador escrito é o mesmo que a instrução anterior precisa
            if( (exmem_op == ALUop) && (exmem_rd == idex_rs1) ) begin
                forwardA = FROM_MEM;
            end
            else if( ((memwb_op == LW) || (memwb_op == ALUop)) && (memwb_rd == idex_rs1) ) begin
                if (memwb_op == ALUop) begin
                    forwardA = FROM_WB_ALU;
                end
                else begin
                    forwardA = FROM_WB_LD;
                end
            end
        end
        //================================================
        // Forward B
        //================================================
        // Conferimos se o registrador 2 é usado (não nulo)
        if (idex_rs2 != 5'd0) begin
            if( (exmem_op == ALUop) && (exmem_rd == idex_rs2) ) begin
                forwardB = FROM_MEM;
            end
            else if( ((memwb_op == LW) || (memwb_op == ALUop)) && (memwb_rd == idex_rs2) ) begin
                if (memwb_op == ALUop) begin
                    forwardB = FROM_WB_ALU;
                end
                else begin
                    forwardB = FROM_WB_LD;
                end
            end
        end
        //================================================

    end ///// always

endmodule
