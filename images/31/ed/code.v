module parity_checker (
    input [3:0] data,
    output reg parity
);
    always @(*) begin
        parity = ~^data; // Even parity: 1 if even number of 1s, 0 if odd number of 1s
    end
endmodule