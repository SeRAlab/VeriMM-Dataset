module rle_encoder (
    input clk,
    input reset,
    input [7:0] data_in,
    input valid_in,
    output reg [15:0] data_out,
    output reg valid_out
);
    reg [7:0] count;
    reg current_value;
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 16'b0;
            valid_out <= 0;
            count <= 0;
            current_value <= 0;
        end else if (valid_in) begin
            count <= 1;
            current_value <= data_in[0];
            valid_out <= 0;

            for (i = 1; i < 8; i = i + 1) begin
                if (data_in[i] == current_value) begin
                    count <= count + 1;
                end else begin
                    data_out <= {current_value, count};
                    valid_out <= 1;
                    current_value <= data_in[i];
                    count <= 1;
                end
            end
            data_out <= {current_value, count}; // Output the last run
            valid_out <= 1;
        end
    end
endmodule