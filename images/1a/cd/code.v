module csprng (
    input wire clk,
    input wire reset,
    output reg [3:0] random_number
);
    reg [3:0] lfsr;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= 4'b1011; // Initial seed
        end else begin
            // LFSR feedback polynomial x^4 + x^3 + 1
            lfsr <= {lfsr[2:0], lfsr[3] ^ lfsr[2]}; 
        end
    end

    always @(posedge clk) begin
        random_number <= lfsr;
    end
endmodule