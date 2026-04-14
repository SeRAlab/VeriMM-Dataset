module mac_filter (
    input [47:0] mac_in,
    input [47:0] mac_filter,
    output reg match
);
    always @(*) begin
        if (mac_in == mac_filter)
            match = 1'b1;
        else
            match = 1'b0;
    end
endmodule