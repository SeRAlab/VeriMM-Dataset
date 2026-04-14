module lfsr (
    input wire clk,
    input wire rstn,
    output reg [4:0] lfsr_out
);

always @(posedge clk)
begin
    if (~rstn)
        lfsr_out <= 5'b00001;
    else
        lfsr_out <= {lfsr_out[3:0], lfsr_out[4] ^ lfsr_out[2]};
end

endmodule