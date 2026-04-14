module loadable_counter (
    input clk,
    input reset,
    input load,
    input enable,
    input [3:0] data,
    output reg [3:0] count);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'b0000;
        end else if (load) begin
            count <= data;
        end else if (enable) begin
            count <= count + 1;
        end
    end
endmodule