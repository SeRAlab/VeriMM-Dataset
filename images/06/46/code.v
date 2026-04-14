module rle_encoder (
    input clk,
    input rst,
    input data_in,
    output reg [3:0] run_length,
    output reg data_out,
    output reg valid
);
    reg [3:0] count;
    reg prev_data;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            run_length <= 0;
            data_out <= 0;
            valid <= 0;
            prev_data <= 0;
        end else begin
            if (data_in == prev_data) begin
                count <= count + 1;
            end else begin
                if (count > 0) begin
                    run_length <= (count > 15) ? 15 : count; // Limit to 15
                    data_out <= prev_data;
                    valid <= 1;
                end else begin
                    valid <= 0;
                end
                prev_data <= data_in;
                count <= 1; // Start counting the new bit
            end
        end
    end

    always @(posedge clk) begin
        if (valid && count > 0) begin
            count <= 0; // Reset count after sending
        end
    end
endmodule