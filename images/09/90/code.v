module ring_counter(
    input clk,
    input rst,
    output reg [3:0] count
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 4'b0001; // Initial state
        end else begin
            count <= {count[2:0], count[3]}; // Shift left
        end
    end
endmodule