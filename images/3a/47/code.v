module down_counter(
    input clk,
    input rst,
    input enable,
    input [3:0] start_value,
    output reg [3:0] count
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= start_value;
        end else if (enable) begin
            if (count > 0) begin
                count <= count - 1;
            end
        end
    end
endmodule