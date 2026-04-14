module top_module(
    input [7:0] bin_in,
    output reg [2:0] count_out
);integer i; // Declare the loop variable 'i' as an integer

    always @* begin
        count_out = 0;
        for (i = 0; i < 8; i = i + 1) begin
            if (bin_in[i] == 1) begin
                count_out = count_out + 1;
            end
        end
    end

endmodule