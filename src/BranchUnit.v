module BranchUnit (
    input  [31:0] pc_ex,
    input  [31:0] rs1_value,
    input  [31:0] rs2_value,
    input  [31:0] instruction,

    output reg        branch_taken,
    output reg [31:0] branch_target
);

    localparam BEQ = 7'b110_0011;

    wire [6:0] opcode;
    assign opcode = instruction[6:0];
    wire [31:0] branch_imm; // Imediato (número) da mudança para o possível branch


    assign branch_imm = {
        {20{instruction[31]}},
        instruction[7],
        instruction[30:25],
        instruction[11:8],
        1'b0
    };

    always @(*) begin
        branch_taken  = 1'b0; // Sinal se houver desvio (por padrão é falso)
        branch_target = pc_ex + 32'd4; // Por padrão passamos para a próxima

	    // Conferir se instrução é BEQ
	      // Tecnicamente não necessário no nosso caso
	      //  mas implementamos como se fosse ter outras instruções
	    if (opcode == BEQ) begin

	        // Comparar valores (se são iguais)
	    	// Registradores já são valores (indicado pelo '_value')
	    	//  então podemos os comparar diretamente ao invés de ter que buscar
	    	//  na memória
	        if (rs1_value == rs2_value) begin

            // Atualizar branch target
	    	    // PC atual + imediato (branch_imm)
	    	branch_target = pc_ex + branch_imm;

	    	// Atualizar branch taken
	    	    // Sinal para indicar que mudamos o path,
	    	    //  assim no RISCVCPU ele vai atribuir o branch_taken
	    	    //  ao PC, ao invés de atribuir o padrão de aumentar em 4
	    	branch_taken = 1'b1;

	        	// Debug: Sinalizar branch
	    	//$display("Branch taken")

	        end ///// if (rs1_value == rs2_value)

	    end ///// if (opcode == BEQ)
    
    end

endmodule
