module top_module(
    input clk,
    input reset, // Synchronous active-high reset
    input [7:0] d, // 8-bit input for the flip-flop module
    output [3:0] counter_q, // 4-bit output from the counter module
    output [7:0] result_q // 8-bit output from the addition module
);// Define the 8 D flip-flops with active high synchronous reset
reg [7:0] shift_reg;
always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 8'h34;
    end else if (enable) begin
        shift_reg <= {shift_reg[6:0], d};
    end
end

// Define the enable signal for the shift register
reg enable;
always @(posedge clk) begin
    if (reset) begin
        enable <= 1'b0;
    end else begin
        enable <= 1'b1;
    end
end

// Define the 4-bit binary counter
reg [3:0] counter;
always @(posedge clk) begin
    if (reset) begin
        counter <= 4'h0;
    end else begin
        counter <= counter + 1;
    end
end

// Define the addition module
wire [7:0] add_result;
assign add_result = shift_reg + counter;

// Assign outputs
assign counter_q = counter;
assign result_q = add_result;

endmodule