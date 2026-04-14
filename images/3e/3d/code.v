module packet_filter (
    input [7:0] packet,
    input [7:0] filter,
    input reset,
    output reg match
);
    always @(*) begin
        if (reset) begin
            match = 0;
        end else begin
            match = (packet == filter) ? 1 : 0;
        end
    end
endmodule