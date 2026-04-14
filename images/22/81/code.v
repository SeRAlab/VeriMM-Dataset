module timer_32bit (
    input clk,
    input reset,
    input enable,
    input load,
    input [31:0] load_value,
    output reg [31:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 32'b0;
        end else if (load) begin
            count <= load_value;
        end else if (enable) begin
            count <= count + 1;
        end
    end
endmodule