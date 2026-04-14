module sync_counter(
    input clk,
    input enable,
    
    output reg [3:0] count
);
    always @(posedge clk) begin
        if (enable)
            count <= count + 1;
    end
endmodule