module async_up_counter (
    input wire clk,
    input wire rst,
    input wire en,
    output reg [63:0] count
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 64'b0;
        end else if (en) begin
            count <= count + 1;
        end
    end

endmodule