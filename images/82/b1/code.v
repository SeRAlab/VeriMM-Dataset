module counter_with_load(
    input clk,
    input load,
    input enable,
    input [5:0] load_value,
    output reg [5:0] count_out
);

    always @(posedge clk) begin
        if (load)
            count_out <= load_value;
        else if (enable)
            count_out <= count_out + 1;
    end

endmodule