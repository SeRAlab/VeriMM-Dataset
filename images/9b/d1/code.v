module counter (
    input clk,
    input enable,
    input up,
    input down,
    output reg [2:0] count
);

    always @(posedge clk) begin
        if (enable) begin
            if (up && !down)
                count <= count + 1;
            else if (down && !up)
                count <= count - 1;
        end
    end

endmodule