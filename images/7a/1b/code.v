module loadable_counter (
    input clk,
    input reset,
    input load,
    input [3:0] load_value,
    output reg [3:0] count
);always @(posedge clk) begin
        if (reset)
            count <= 4'b0000;
        else if (load)
            count <= load_value;
    end

endmodule