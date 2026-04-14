module top_module(clk, reset, load, data_in, count);input clk, reset, load;
input [3:0] data_in;
output reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0;
    end
    else if (load) begin
        count <= data_in;
    end
    else begin
        count <= count + 1;
    end
end

endmodule