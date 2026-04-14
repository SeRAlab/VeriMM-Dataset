module parity_generator (
    input [7:0] data_in,
    output reg parity_out);always @(*) begin
        parity_out = ^data_in;
    end

endmodule