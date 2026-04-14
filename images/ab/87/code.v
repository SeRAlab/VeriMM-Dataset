module top_module(
    input wire clk,
    input wire rst,
    input wire en,
    input wire up_down,
    output reg [3:0] count
);always @(posedge clk or negedge rst) begin
    if(!rst) begin
        count <= 4'b0;
    end else if(en) begin
        if(up_down) begin
            count <= count + 1;
        end else begin
            count <= count - 1;
        end
    end
end

endmodule