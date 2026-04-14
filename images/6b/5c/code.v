module up_down_counter (
    input clk,
    input dir,
    output reg [3:0] count
);

    always_ff @(posedge clk) begin
        if (dir)
            count <= count - 1;
        else
            count <= count + 1;
    end

endmodule