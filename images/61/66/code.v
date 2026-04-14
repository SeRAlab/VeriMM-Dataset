module top_module(
    input clk,
    input load,
    input up_down,
    output reg [3:0] count
);always @(posedge clk) begin
        if (load) begin
            count <= 4'b0000;
        end else if (up_down) begin
            count <= count + 1;
        end else begin
            count <= count - 1;
        end
    end

endmodule