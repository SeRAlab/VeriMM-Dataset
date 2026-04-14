module parity_checker (
    input [3:0] data,
    output reg parity
);
    always @(*) begin
        parity = ~(^data); // Even parity: output 1 if even number of 1's, 0 otherwise
    end
endmodule