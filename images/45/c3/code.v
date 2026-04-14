module top_module(
    input clk,
    input reset,      // Asynchronous active-high reset
    output reg [3:0] counter_out, // 4-bit output from the counter
    input select, // Select input for the multiplexer
    output reg [3:0] q // 4-bit output from the selected input
);// Counter module
reg [3:0] count_reg;
always @(posedge clk, negedge reset) begin
    if (!reset) begin
        count_reg <= 4'b0000;
    end else begin
        count_reg <= count_reg + 1;
    end
end
assign counter_out = count_reg;

// Priority encoder module
wire [1:0] select_bin;
assign select_bin = (select == 1'b1) ? 2'b10 : 2'b01;

// Decoder module
always @(*) begin
    case (select_bin)
        2'b00: q = 4'b0000;
        2'b01: q = counter_out;
        2'b10: q = counter_out + 4'b0001;
        2'b11: q = 4'b1111;
    endcase
end

endmodule