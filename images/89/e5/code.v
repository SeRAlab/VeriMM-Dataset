module top_module (
    input clk,
    input rst,
    input enable,
    output reg [4:0] count);always @(posedge clk) begin
        if (rst)
            count <= 5'b00001;
        else if (enable)
            count <= {count[3:0], count[4]};
    end
    
endmodule