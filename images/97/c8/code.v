module top_module(
    input clk,
    input up_down,
    input load,
    input [3:0] input_data,
    output reg [3:0] Q
);always @(posedge clk) begin
        if (load) begin
            Q <= input_data;
        end else begin
            if (up_down) begin
                Q <= Q + 1;
            end else begin
                Q <= Q - 1;
            end
        end
    end

endmodule