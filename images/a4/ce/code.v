module top_module(input clk, input rst, input data, output reg [2:0] q);reg [2:0] q_temp;
    
    always @(posedge clk or negedge rst) begin
        if (rst == 0) begin
            q_temp <= 3'b0;
        end
        else begin
            q_temp <= {q_temp[1:0], data};
        end
    end
    
    assign q = q_temp;
endmodule