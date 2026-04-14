module sync_up_counter(
    input wire clk,
    input wire enable,
    input wire reset,
    input wire load,
    input wire [3:0] data,
    output reg [3:0] count
    );

always @(posedge clk or posedge reset) begin
    if (reset)
        count <= 4'b0000;
    else if (load)
        count <= data;
    else if (enable)
        count <= count + 1;
end

endmodule