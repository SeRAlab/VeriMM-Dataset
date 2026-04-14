module top_module(
    input clk,
    input reset,
    input up_down,
    input load,
    input [3:0] data_in,
    output reg [3:0] count
);always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'b0;
        end else begin
            if (load) begin
                count <= data_in;
            end else begin
                if (up_down) begin
                    count <= count + 1;
                end else begin
                    count <= count - 1;
                end
            end
        end
    end

endmodule