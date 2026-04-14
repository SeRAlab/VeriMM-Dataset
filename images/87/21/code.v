module top_module(
    input [3:0] in,
    output reg count
);reg [2:0] i;
    reg [3:0] current_bit;
    reg [2:0] ones_count;

    always @* begin
        ones_count = 0;
        for (i = 0; i < 4; i = i + 1) begin
            current_bit = in[i];
            if (current_bit == 1) begin
                ones_count = ones_count + 1;
            end
        end
        count = ones_count;
    end

endmodule