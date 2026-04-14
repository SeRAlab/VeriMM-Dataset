module top_module(
    input clk,
    input reset,
    input load,
    input mode,
    input [3:0] data_in,
    output reg [3:0] result
);reg [3:0] counter;

always @(posedge clk) begin
    if (reset) begin
        counter <= 4'b0;
    end else if (load) begin
        counter <= data_in;
    end else begin
        if (mode) begin
            counter <= counter + 1;
        end else begin
            counter <= counter - 1;
        end
    end
end

assign result = counter;

endmodule