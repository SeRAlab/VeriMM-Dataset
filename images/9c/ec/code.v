module top_module(
    input [3:0] a,                 // 4-bit input a
    input [3:0] b,                 // 4-bit input b
    input [2:0] sel,               // Select input to choose 4-bit input
    input [3:0] data0,             // 4-bit input 0
    input [3:0] data1,             // 4-bit input 1
    input [3:0] data2,             // 4-bit input 2
    input [3:0] data3,             // 4-bit input 3
    input [3:0] data4,             // 4-bit input 4
    input [3:0] data5,             // 4-bit input 5
    input clk,                     // Clock input for flag update
    output reg flag                // Flag indicating if a > b
);reg [3:0] selected_input;
reg [3:0] complemented_input;
reg [3:0] sum;
reg carry_out;

// 6-to-1 multiplexer
always @(*) begin
    case (sel)
        3'b000: selected_input = data0;
        3'b001: selected_input = data1;
        3'b010: selected_input = data2;
        3'b011: selected_input = data3;
        3'b100: selected_input = data4;
        3'b101: selected_input = data5;
        default: selected_input = 4'b0;
    endcase
    
    if (sel[0] == 1) begin
        complemented_input = ~selected_input;
    end
    else begin
        complemented_input = selected_input;
    end
end

// Half adder for sum calculation
always @(*) begin
    // Simple half adder logic (a + b) with carry-out
    {carry_out, sum} = a + complemented_input;
end

// 4-bit magnitude comparator logic
always @(*) begin
    if (sum > selected_input) begin
        flag = 1'b1; // a > b
    end
    else begin
        flag = 1'b0; // a <= b
    end
end

// Update flag on clock edge
always @(posedge clk) begin
    // Original flag update logic removed to avoid inconsistency
end

endmodule