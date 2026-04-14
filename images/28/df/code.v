module rle_encoder (
    input clk,
    input reset,
    input enable,
    input data_in,
    output reg [3:0] count_out,
    output reg data_out_valid,
    output reg data_out
);
    reg [3:0] count;
    reg last_data;
    reg encoding_done;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            last_data <= 0;
            count_out <= 0;
            data_out_valid <= 0;
            encoding_done <= 0;
        end else if (enable) begin
            if (data_in == last_data) begin
                count <= count + 1;
            end else begin
                if (count > 0) begin
                    count_out <= count;
                    data_out <= last_data;
                    data_out_valid <= 1;
                    count <= 1; // reset count for new bit
                end
                last_data <= data_in;
            end
        end else begin
            if (encoding_done == 0 && count > 0) begin
                count_out <= count;
                data_out <= last_data;
                data_out_valid <= 1;
                encoding_done <= 1; // complete encoding
            end
        end
    end
endmodule