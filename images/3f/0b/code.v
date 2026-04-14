module tcp_segmentation (
    input wire clk,
    input wire reset,
    input wire [31:0] data_in,
    input wire valid_in,
    input wire [15:0] mss,
    output reg [31:0] segment_out,
    output reg valid_out,
    output reg done
);
    
    reg [15:0] data_count;
    reg [31:0] buffer;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            segment_out <= 32'b0;
            valid_out <= 0;
            done <= 0;
            data_count <= 0;
            buffer <= 32'b0;
        end else begin
            if (valid_in) begin
                buffer <= data_in;
                data_count <= data_count + 1;
                if (data_count < mss) begin
                    segment_out <= buffer;
                    valid_out <= 1;
                end else begin
                    segment_out <= buffer;
                    valid_out <= 1;
                    done <= 1;
                    data_count <= 0; // Reset count for new segment
                end
            end else begin
                valid_out <= 0;
                done <= 0;
            end
        end
    end
endmodule