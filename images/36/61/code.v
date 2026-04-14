module audio_compression (
    input clk,
    input rst,
    input [7:0] audio_sample,
    input valid,
    output reg [7:0] encoded_value,
    output reg [3:0] run_length,
    output reg ready
);
    reg [7:0] current_value;
    reg [3:0] count;
    reg processing;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            encoded_value <= 8'd0;
            run_length <= 4'd0;
            count <= 4'd0;
            current_value <= 8'd0;
            ready <= 1'b0;
            processing <= 1'b0;
        end else if (valid) begin
            if (!processing) begin
                current_value <= audio_sample;
                count <= 4'd1;
                processing <= 1'b1;
            end else if (audio_sample == current_value) begin
                count <= count + 1;
            end else begin
                encoded_value <= current_value;
                run_length <= count;
                current_value <= audio_sample;
                count <= 4'd1;
            end
        end else if (processing) begin
            encoded_value <= current_value;
            run_length <= count;
            ready <= 1'b1;
            processing <= 1'b0;
        end else begin
            ready <= 1'b0;
        end
    end
endmodule