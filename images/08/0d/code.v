module up_counter #(parameter MAX_VALUE = 15) (
    input wire clk,
    input wire reset,
    input wire enable,
    output reg [3:0] count
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
        end else if (enable) begin
            if (count < MAX_VALUE) begin
                count <= count + 1;
            end else begin
                count <= 0;
            end
        end
    end
endmodule