module lfsr_6bit (
    input wire clk,
    input wire rst,
    output reg [5:0] lfsr
    );

always @(posedge clk) begin
    if (rst) begin
        lfsr <= 6'b000001;
    end else begin
        lfsr <= {lfsr[4:0], lfsr[5] ^ lfsr[4]};
    end
end

endmodule