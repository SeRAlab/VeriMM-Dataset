module DWT (
    input clk,
    input reset,
    input [15:0] data_in,
    input valid_in,
    output reg [15:0] low_out,
    output reg [15:0] high_out,
    output reg valid_out
);
    reg [15:0] sample[0:1];
    reg [1:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            valid_out <= 0;
        end else if (valid_in) begin
            sample[count] <= data_in;
            count <= count + 1;

            if (count == 1) begin
                low_out <= (sample[0] + sample[1]) >> 1; // Average
                high_out <= sample[0] - sample[1]; // Difference
                valid_out <= 1;
                count <= 0; // Reset count for the next pair
            end else begin
                valid_out <= 0; // Signal not valid until we have two samples
            end
        end
    end
endmodule