module top_module(rstn, clk, up, down, count);// Default parameter. This can be overridden
    parameter WIDTH = 8;
    
    input rstn;
    input clk;
    input up;
    input down;
    output reg [WIDTH-1:0] count;
    
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            count <= 0;
        end else begin
            if (up && !down) begin
                count <= count + 1;
            end else if (!up && down) begin
                count <= count - 1;
            end
        end
    end
endmodule