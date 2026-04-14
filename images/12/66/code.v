module ring_counter (
    input clk,
    input rst,
    output reg [4:0] count
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 5'b00001; // Reset to '00001'
    end else begin
        count <= {count[3:0], count[4]}; // Shift the '1' around
    end
end

endmodule