module async_down_counter_with_reset (
    input wire clk,
    input wire rst,
    input wire en,
    output reg [9:0] count
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 10'b1111111111;
        end else if (en) begin
            count <= count - 1;
        end
    end

endmodule