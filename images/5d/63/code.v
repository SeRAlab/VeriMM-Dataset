module top_module(
    input clk,
    input reset,            // Synchronous reset for second shift register
    input load,             // Load input for first shift register
    input [7:0] data_in_1,  // Data input for first shift register
    input [7:0] data_in_2,  // Data input for second shift register
    output [7:0] functional_output // Output from functional module (OR of both shift registers)
);reg [7:0] shift_reg_1;
reg [7:0] shift_reg_2;
wire [7:0] or_output;

// First shift register
always @(posedge clk) begin
    if (load) begin
        shift_reg_1 <= data_in_1;
    end else begin
        shift_reg_1 <= {shift_reg_1[6:0], shift_reg_1[7]};
    end
end

// Second shift register
always @(posedge clk) begin
    if (reset) begin
        shift_reg_2 <= 8'b0;
    end else begin
        shift_reg_2 <= {shift_reg_2[6:0], shift_reg_2[7]};
    end
end

// Functional module (OR of both shift registers)
assign or_output = shift_reg_1 | shift_reg_2;
assign functional_output = or_output;

endmodule