module top_module(
    input [3:0] A,   // 4-bit input for adder/subtractor
    input [3:0] B,   // 4-bit input for adder/subtractor
    input sub,       // Input for adder/subtractor to choose between addition and subtraction
    input RST,       // Asynchronous active-low reset input for counter
    input clk,       // Clock input for the counter
    output [3:0] Q,  // 4-bit output from counter
    output [3:0] sum, // 4-bit output from adder/subtractor
    output overflow,  // Output from adder/subtractor to indicate overflow
    output [3:0] final_output // 4-bit output from functional module
);reg [3:0] counter;
wire [3:0] adder_output;

// Counter module
always @(posedge clk or negedge RST) begin
    if (!RST) begin
        counter <= 4'b0000;
    end else begin
        counter <= counter + 1;
    end
end

// Adder/subtractor module
assign sum = sub ? A - B : A + B;
assign overflow = (sum[3] == 1 && sub == 0) || (sum[3] == 0 && sub == 1);

// Functional module
assign final_output = counter + sum; // Use sum as adder_output

// Output counter value
assign Q = counter;

endmodule