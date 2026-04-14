module data_transformer (
    input clk,
    input [31:0] data_in,
    output [15:0] data_out
);

reg [7:0] first_eight_bits;
reg [7:0] last_eight_bits;

always @(posedge clk) begin
    if (data_in[31:24] == 8'hFF) begin
        first_eight_bits <= 8'hFF;
        last_eight_bits <= 8'h00;
    end else if (data_in[7:0] == 8'h00) begin
        first_eight_bits <= 8'h00;
        last_eight_bits <= 8'h0F;
    end else begin
        first_eight_bits <= data_in[31:24];
        last_eight_bits <= data_in[7:0];
    end
end

assign data_out = {first_eight_bits, last_eight_bits};

endmodule