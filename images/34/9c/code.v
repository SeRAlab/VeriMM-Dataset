module tcp_segmentation (
    input [15:0] data_in,
    input segment,
    output reg [7:0] data_out1,
    output reg [7:0] data_out2,
    output reg [15:0] data_out_full
);
    always @(*) begin
        if (segment) begin
            data_out1 = data_in[15:8]; // Upper 8 bits
            data_out2 = data_in[7:0];  // Lower 8 bits
            data_out_full = 16'b0;     // No full data output
        end else begin
            data_out_full = data_in;   // Pass the full data through
            data_out1 = 8'b0;          // No segmented output
            data_out2 = 8'b0;          // No segmented output
        end
    end
endmodule