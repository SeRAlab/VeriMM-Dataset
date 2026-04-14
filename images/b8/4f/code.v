module top_module(
    input clk,           // Added the clk input
    input [3:0] A,
    input [3:0] B,
    output [7:0] OUT
);reg [7:0] result;
    reg [3:0] shift_reg;
    wire [3:0] shifted_B;
    wire carry;
    
    assign shifted_B = {B[2:0], 1'b0};
    
    // Initialize result and shift_reg
    initial begin
        result = 8'b0;
        shift_reg = 4'b0;
    end

    // Pipeline Stage 1
    always @(*) begin
        result = A * shifted_B[0];
        shift_reg = shifted_B;
    end
    
    // Pipeline Stage 2
    always @(posedge clk) begin
        result = result + {shift_reg[3], shift_reg[3:1]};
        shift_reg = {shift_reg[2:0], carry};
    end
    
    // Pipeline Stage 3
    always @(posedge clk) begin
        result = result + {shift_reg[3], shift_reg[3:1]};
        shift_reg = {shift_reg[2:0], carry};
    end
    
    // Pipeline Stage 4
    always @(posedge clk) begin
        result = result + {shift_reg[3], shift_reg[3:1]};
        shift_reg = {shift_reg[2:0], carry};
    end
    
    // Output
    assign OUT = result;
endmodule