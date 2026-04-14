module packet_filter (
    input [7:0] packet_in,
    output reg accept
);
    parameter FILTER_VALUE = 8'b10101010;

    always @(*) begin
        if (packet_in == FILTER_VALUE)
            accept = 1;
        else
            accept = 0;
    end
endmodule