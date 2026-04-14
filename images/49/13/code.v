module even_odd_checker (
    input [3:0] value,
    output reg even,
    output reg odd
);

    always @(*) begin
        if (value[0] == 0) begin
            even = 1;
            odd = 0;
        end else begin
            even = 0;
            odd = 1;
        end
    end
endmodule