module timer (
    input clk,
    input rst,
    input enable,
    input [15:0] max_value,
    output reg [15:0] count
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 16'b0;
        end else if (enable) begin
            if (count == max_value) begin
                count <= 16'b0; // wrap around
            end else begin
                count <= count + 1;
            end
        end
    end
endmodule