module hough_transform (
    input [3:0] pixel,
    output reg [7:0] angle,
    output reg [7:0] distance
);
    always @(*) begin
        if (pixel == 4'b0001) begin
            angle = 8'd45;     // Example angle for the detected line
            distance = 8'd100; // Example distance for the detected line
        end else if (pixel == 4'b0010) begin
            angle = 8'd90;
            distance = 8'd80;
        end else if (pixel == 4'b0100) begin
            angle = 8'd135;
            distance = 8'd120;
        end else begin
            angle = 8'd0;
            distance = 8'd0;
        end
    end
endmodule