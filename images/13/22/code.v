module pipeline(input clk, input rst, input [3:0] in, output reg [3:0] out);
    reg [3:0] stage1;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1 <= 0;
            out <= 0;
        end else begin
            stage1 <= in + 1; // Stage 1: Increment input by 1
            out <= stage1 * 2; // Stage 2: Double the output of stage 1
        end
    end
endmodule