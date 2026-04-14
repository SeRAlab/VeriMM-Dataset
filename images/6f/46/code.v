module top_module(
    input [31:0] input_num,
    output reg [31:0] output_num  // Changed wire to reg
);reg [31:0] count;
    integer i;

    always @(*) begin
        count = 0;
        for (i = 0; i < 32; i = i + 1) begin
            if (input_num[i] == 1'b1) begin
                count = count + 1;
            end
        end
        output_num = count;  // This assignment is now valid
    end

endmodule