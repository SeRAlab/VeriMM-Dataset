module RLE_Compressor (
    input clk,
    input reset,
    input [7:0] sample_in,
    output reg [7:0] sample_out,
    output reg [7:0] run_length
);
    reg [7:0] current_sample;
    reg [7:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_sample <= 8'b0;
            count <= 8'b0;
            sample_out <= 8'b0;
            run_length <= 8'b0;
        end else begin
            if (sample_in == current_sample) begin
                count <= count + 1;
            end else begin
                sample_out <= current_sample;
                run_length <= count;
                current_sample <= sample_in;
                count <= 8'b1; // reset count to 1 for the new sample
            end
        end
    end

    always @(posedge clk) begin
        if (sample_in != current_sample && count > 0) begin
            sample_out <= current_sample;
            run_length <= count;
        end
    end
endmodule