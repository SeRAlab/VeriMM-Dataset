module top_module(
    input clk,
    input load,
    input up_down,
    input [2:0] data,
    output reg [2:0] count
);always @(posedge clk) begin
        if (load) begin
            count <= data;
        end else begin
            if (up_down) begin
                count <= count + 1;
            end else begin
                count <= count - 1;
            end
        end
    end

endmodule