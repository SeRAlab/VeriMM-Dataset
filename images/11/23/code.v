module ring_counter (
    input wire clk,
    input wire rst,
    output reg [4:0] count
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 5'b00001; // Initialize to state 1
    end else begin
        count <= {count[3:0], count[4]}; // Shift operation for ring counter
    end
end

endmodule