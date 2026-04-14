module sync_set_counter (
    input clk,
    input enable,
    input set,
    input [7:0] set_value,
    output reg [7:0] count
);

    always @(posedge clk) begin
        if (set)
            count <= set_value;
        else if (enable)
            count <= count + 1;
    end

endmodule