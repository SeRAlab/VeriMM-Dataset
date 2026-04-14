module packet_filter(
    input [7:0] packet,
    input [7:0] filter,
    output reg pass,
    output reg fail
);
    always @(*) begin
        if (packet == filter) begin
            pass = 1'b1;
            fail = 1'b0;
        end else begin
            pass = 1'b0;
            fail = 1'b1;
        end
    end
endmodule