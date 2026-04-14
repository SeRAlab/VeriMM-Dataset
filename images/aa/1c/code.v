module top_module(
    input [3:0] A,
    input [3:0] B,
    input dir,
    input [2:0] op,
    output [3:0] S
);// Barrel Shifter
    wire [3:0] shifted_value;
    assign shifted_value = (dir) ? {A[2:0], 1'b0} : {1'b0, A[3:1]};
    
    // ALU
    wire [3:0] alu_result;
    assign alu_result = (op == 3'b000) ? (A + shifted_value) :
                        (op == 3'b001) ? (A - shifted_value) :
                        (op == 3'b010) ? (A & shifted_value) :
                        (op == 3'b011) ? (A | shifted_value) :
                        (op == 3'b100) ? (A ^ shifted_value) :
                        (op == 3'b101) ? (shifted_value << 1) :
                        4'b0;
    
    // Output
    assign S = alu_result;
    
endmodule