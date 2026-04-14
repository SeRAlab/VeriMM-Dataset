module tcp_segmenter(
    input wire clk,
    input wire rst,
    input wire [31:0] data_in,
    input wire [15:0] mss,
    output reg [15:0] data_out,
    output reg more_data
);

reg [31:0] remaining_data;
reg [4:0] current_segment;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        data_out <= 16'b0;
        more_data <= 1'b0;
        remaining_data <= 32'b0;
        current_segment <= 5'b0;
    end else begin
        if (current_segment == 5'b0) begin
            remaining_data <= data_in;
            if (remaining_data <= {16'b0, mss}) begin
                data_out <= remaining_data[15:0];
                more_data <= 1'b0;
                current_segment <= current_segment + 1;
            end else begin
                data_out <= mss;
                more_data <= 1'b1;
                remaining_data <= remaining_data - {16'b0, mss};
                current_segment <= current_segment + 1;
            end
        end else if (remaining_data > 0) begin
            if (remaining_data <= {16'b0, mss}) begin
                data_out <= remaining_data[15:0];
                more_data <= 1'b0;
                remaining_data <= 0;
            end else begin
                data_out <= mss;
                more_data <= 1'b1;
                remaining_data <= remaining_data - {16'b0, mss};
            end
        end
    end
end

endmodule