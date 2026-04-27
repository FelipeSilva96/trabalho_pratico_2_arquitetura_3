module HazardDetectionUnit (
    input [4:0] idex_rs1,
    input [4:0] idex_rs2,
    input [4:0] exmem_rd,

    input [6:0] idex_op,
    input [6:0] exmem_op,

    output reg stall
);

    localparam LW    = 7'b000_0011;
    localparam SW    = 7'b010_0011;
    localparam BEQ   = 7'b110_0011;
    localparam ALUop = 7'b001_0011;

    initial begin
        stall = 1'b0;
    end

    always @(*) begin
        stall = 1'b0;

        // Load-use hazard:
        // If the instruction in EX/MEM is a load and the instruction in ID/EX
        // uses its destination register, the pipeline must stall one cycle.

        // Conferir tipo da instrução (no EX/MEM)
	      // Tecnicamente não necessário no nosso caso
	      //  mas implementamos como se fosse ter outras instruções
        // Para load
        if (exmem_op == LW) begin
            // Se a próxima instrução (no ID/EX) usar o mesmo registrador do load
            if (idex_rs1 == exmem_rd || idex_rs2 == exmem_rd) begin
                // Dar stall
                stall = 1'b1;
            end ///// if (idex_rs1 == exmem_rd || idex_rs2 == exmem_rd)
        end ///// if (exmem_op == LW)

    end

endmodule
