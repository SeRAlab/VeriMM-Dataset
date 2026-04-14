module lfsr_32bit (
    input wire clk,
    input wire rst,
    output reg [31:0] lfsr
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr <= 32'hFFFFFFFF; // Initialize to a non-zero value
        end else begin
            lfsr <= {lfsr[30:0], lfsr[31] ^ lfsr[22] ^ lfsr[21] ^ lfsr[17]};
        end
    end
endmodule