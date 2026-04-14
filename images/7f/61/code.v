module up_down_counter(
    input clk,
    input rst,
    input up,
    
    output reg [2:0] count
);
    always @(posedge clk) begin
        if (rst) begin
            count <= 3'b000;
        end else if (up) begin
            count <= count + 1;
        end else begin
            count <= count - 1;
        end
    end
endmodule