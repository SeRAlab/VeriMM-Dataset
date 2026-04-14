module max_value (
    input [15:0] in,
    output reg [15:0] out
);

    reg [15:0] max_val;
    integer i;

    always @(*) begin
        max_val = in[0];
        for (i = 1; i < 16; i = i + 1) begin
            if (in[i] > max_val) begin
                max_val = in[i];
            end
        end
        out = max_val;
    end

endmodule