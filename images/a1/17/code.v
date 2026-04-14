module top_module(
    input [11:0] address,
    input clock,
    output reg [11:0] q // Changed output to reg type
);wire [11:0] output_value;

assign output_value = (address >= 12'd0 && address <= 12'd1023) ? 12'b0 :
                      (address >= 12'd1024 && address <= 12'd2047) ? address :
                      (address >= 12'd2048 && address <= 12'd3071) ? (address & 12'b111111111111) :
                      (address >= 12'd3072 && address <= 12'd4095) ? (address | 12'b100000000000) :
                      12'b0;

always @(posedge clock) begin
    q <= output_value;
end

endmodule