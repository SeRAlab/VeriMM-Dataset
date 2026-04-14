module top_module(
    input clk,
    input rst,
    input ctrl,
    input en,
    input load,
    input [3:0] in,
    output reg [3:0] out
);reg [3:0] count;

always @(posedge clk) begin
    if (rst) begin
        count <= 4'b0;
    end
    else if (load) begin
        count <= in;
    end
    else if (en) begin
        if (ctrl) begin
            count <= count + 4'b1;
        end
        else begin
            count <= count - 4'b1;
        end
    end
end

assign out = count;

endmodule