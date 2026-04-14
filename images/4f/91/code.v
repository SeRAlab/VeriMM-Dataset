module top_module(
    input [31:0] in_vector,
    output reg [5:0] out_count
);integer i;
    reg [5:0] count;

    always @(*) begin
        count = 0;
        for (i = 0; i < 32; i = i + 1) begin
            if (in_vector[i] == 1) begin
                count = count + 1;
            end
        end
        out_count = count;
    end

endmodule