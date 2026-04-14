module packet_filter(
    input [15:0] packet_data,
    output reg allow
);
    always @(*) begin
        if (packet_data == 16'b1010101010101010 || packet_data == 16'b1111000011110000) begin
            allow = 1;
        end else begin
            allow = 0;
        end
    end
endmodule