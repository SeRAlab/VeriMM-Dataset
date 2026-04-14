module down_counter_3bit(
    input clk,
    input enable,
    input load,
    input [2:0] load_val,
    output reg [2:0] count
    );

    always @(posedge clk)
    begin
        if (load)
            count <= load_val;
        else if (enable)
            count <= count - 1;
    end

endmodule