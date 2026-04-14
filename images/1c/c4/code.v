module rle_encoder (
    input clk,
    input reset,
    input data_in,
    output reg [7:0] count_out,
    output reg value_out,
    output reg valid
);
    reg [7:0] count;
    reg prev_value;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            valid <= 0;
            count_out <= 0;
            value_out <= 0;
            prev_value <= 0;
        end else begin
            if (count == 0) begin
                prev_value <= data_in;
                count <= 1;
            end else if (data_in == prev_value) begin
                count <= count + 1;
            end else begin
                count_out <= count;
                value_out <= prev_value;
                valid <= 1;
                count <= 1;
                prev_value <= data_in;
            end
            
            if (valid) begin
                count <= 0;  // reset count after output
            end
        end
    end
endmodule