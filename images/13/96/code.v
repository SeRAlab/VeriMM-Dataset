module down_counter(
    input clk,
    input rst,
    input load,
    input [3:0] load_value,
    input enable,
    output reg [3:0] count
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 4'b0000;
        end else if (load) begin
            count <= load_value;
        end else if (enable && count > 0) begin
            count <= count - 1;
        end
    end
endmodule