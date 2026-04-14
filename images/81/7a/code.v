module top_module(
    input clk,              // Clock input
    input reset,            // Synchronous active-high reset
    input [15:0] A,         // 16-bit input A
    input [15:0] B,         // 16-bit input B
    input C,                // Control input for add/subtract operation
    output [15:0] Q,        // 16-bit output Q
    input shift,            // Shift input of the shift register
    input load,             // Load input of the shift register
    input [3:0] data_in,    // Data input of the shift register
    output reg [3:0] out    // Output of the shift register
);// Adder/Subtractor module
reg [15:0] sum;
always @ (posedge clk or posedge reset) begin
    if (reset) begin
        sum <= 0;
    end else begin
        if (C) begin
            sum <= A - B;
        end else begin
            sum <= A + B;
        end
    end
end
assign Q = sum;

// Shift register module
reg [3:0] shift_reg;
always @ (posedge clk or posedge reset) begin
    if (reset) begin
        shift_reg <= 0;
    end else begin
        if (load) begin
            shift_reg <= data_in;
        end else if (shift) begin
            shift_reg <= {shift_reg[2:0], 1'b0};
        end
    end
end
assign out = shift_reg;

// Functional module
reg [3:0] and_result;
always @ (posedge clk or posedge reset) begin
    if (reset) begin
        and_result <= 0;
    end else begin
        and_result <= sum[3:0] & out;
    end
end

// Note: Removed the internal instantiation of the module as it causes hierarchy issues
// The module definition is complete on its own without instantiation

endmodule