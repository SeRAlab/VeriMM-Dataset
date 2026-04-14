module counter_32bit (
    input wire clk,
    input wire reset,
    input wire enable,
    output reg [31:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset) 
            count <= 32'b0;
        else if (enable) 
            count <= count + 1;
    end
endmodule