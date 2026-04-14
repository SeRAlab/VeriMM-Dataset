module timer (
    input clk,
    input rst,
    input enable,
    output reg [15:0] count
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 16'b0;
        end else if (enable) begin
            if (count < 16'hFFFF) begin
                count <= count + 1;
            end
        end
    end
endmodule