module counter(
    input wire clk,
    input wire reset,
    input wire enable,
    output reg [2:0] count
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 3'b000;
        end else if (enable) begin
            if (count == 3'b111) begin
                count <= 3'b000;
            end else begin
                count <= count + 1;
            end
        end
    end
endmodule