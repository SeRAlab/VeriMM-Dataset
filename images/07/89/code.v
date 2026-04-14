module rle_encoder (
    input clk,
    input reset,
    input [7:0] data_in,
    input valid_in,
    output reg [8:0] rle_out,
    output reg valid_out
);
    reg [7:0] current_data;
    reg [3:0] count;
    reg encoding;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rle_out <= 9'b0;
            valid_out <= 0;
            current_data <= 0;
            count <= 0;
            encoding <= 0;
        end else begin
            if (valid_in) begin
                if (!encoding) begin
                    current_data <= data_in;
                    count <= 1;
                    encoding <= 1;
                end else if (data_in == current_data) begin
                    if (count < 8) begin
                        count <= count + 1;
                    end else begin
                        rle_out <= {1'b1, current_data}; // output 8
                        valid_out <= 1;
                        encoding <= 0;
                    end
                end else begin
                    rle_out <= {count[2:0], current_data}; // output length 1-7
                    valid_out <= 1;
                    current_data <= data_in;
                    count <= 1;
                end
            end else if (encoding) begin
                rle_out <= {count[2:0], current_data}; // flush remaining
                valid_out <= 1;
                encoding <= 0;
            end else begin
                valid_out <= 0; // no valid output
            end
        end
    end
endmodule