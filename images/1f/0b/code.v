module parity_checker(
    input [4:0] data_in,
    output reg parity_out
);
    always @(*) begin
        parity_out = ~^data_in; // Even parity check
    end
endmodule