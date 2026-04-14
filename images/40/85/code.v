module CSPRNG (
    input clk,
    input reset,
    output reg [4:0] random_number
);
    
    reg [4:0] lfsr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= 5'b00001; // non-zero initial state
        end else begin
            // LFSR feedback polynomial: x^5 + x^2 + 1
            lfsr <= {lfsr[3:0], lfsr[4] ^ lfsr[1]};
        end
    end

    always @(posedge clk) begin
        random_number <= lfsr;
    end
endmodule