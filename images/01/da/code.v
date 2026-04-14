module timer (
    input clk,
    input rst,
    input load,
    input enable,
    input [15:0] max_value,
    output reg [15:0] count
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 16'b0;
        end else if (load) begin
            count <= max_value;
        end else if (enable) begin
            if (count < max_value) begin
                count <= count + 1;
            end else begin
                count <= 16'b0;
            end
        end
    end
endmodule