module ForwardingUnit (
    input  [4:0] idex_rs1,
    input  [4:0] idex_rs2,
    input  [4:0] exmem_rd,
    input  [4:0] memwb_rd,

    input  [6:0] exmem_op,
    input  [6:0] memwb_op,

    output reg [1:0] forwardA,
    output reg [1:0] forwardB
);

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

        // EX
        if( exmem_op == ALUop && (exmem_rd != 5'd0) ) begin 
           //================================================
            // Forward A
            if (memwb_rd == idex_rs1) begin
                forwardA = FROM_WB_ALU;
            end

            // Forward B
            if (memwb_rd == idex_rs2) begin
                forwardB = FROM_WB_ALU;
            end
            //================================================
        end
        // MEM
            // A checagem do MEM vai depois pois o MEM precisa que as condições
            //  do EX não sejam válidas, mas o mesmo não se aplica para o EX
        else if( exmem_op == LW && (memwb_rd != 5'd0) ) begin 
           //================================================
            // Forward A
            if (memwb_rd == idex_rs1) begin
                forwardA = FROM_MEM;
            end

            // Forward B
            if (memwb_rd == idex_rs2) begin
                forwardB = FROM_MEM;
            end
            //================================================
        end

    end ///// always

endmodule
