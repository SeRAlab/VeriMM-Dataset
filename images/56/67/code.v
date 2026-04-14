module top_module(
    input clk,
    input resetn,
    output reg [7:0] count
);always@(posedge clk or negedge resetn) begin
        if(~resetn) begin
            count <= 'b0;
        end else begin
            count <= count + 1'b1;
        end
    end

endmodule