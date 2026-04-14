module counter_5bit_load(
    input clk, reset, load,
    input [4:0] data_in,
    output reg [4:0] count);
    
    always @(posedge clk) begin
        if (reset)
            count <= 5'b0;
        else if (load)
            count <= data_in;
        else
            count <= count + 1;
    end
endmodule