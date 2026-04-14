module up_counter_with_load (
    input clk,
    input reset,
    input enable,
    input load,
    input [3:0] load_value,
    output reg [3:0] count
);always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 4'b0000;
    end else if (load) begin
        count <= load_value;
    end else if (enable) begin
        count <= count + 1;
    end
end

endmodule