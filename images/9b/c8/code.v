module top_module(
    input clk_div,
    input rst,
    input [2:0] c_state,
    output reg [4:0] count
    );always@(posedge clk_div)begin
        if(rst)
        begin
            count <= 5'd0;
        end
        else
        begin
            if((c_state == 3'd0) || (c_state == 3'd3))
            begin
                if(count >= 4)   count <= 5'd0;
                else count <= count + 5'd1;
            end
            else
            begin
                if(count >= 1)   count <= 5'd0;
                else count <= count + 5'd1;
            end
        end
    end
endmodule