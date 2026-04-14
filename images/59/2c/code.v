module top_module (
    input clk,
    input reset,
    output reg [4:0] lfsr
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= 5'b00001; // Non-zero seed value
        end else begin
            lfsr <= {lfsr[3:0], lfsr[4] ^ lfsr[2]};
        end
    end

endmodule