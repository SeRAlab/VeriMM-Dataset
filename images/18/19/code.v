module checksum_calculator (
    input [3:0] data_in,
    output reg [7:0] checksum_out
);
    always @(*) begin
        checksum_out = {4'b0000, data_in} + {4'b0000, data_in[3:0]} + {4'b0000, data_in[3:0]} + {4'b0000, data_in[3:0]};
    end
endmodule