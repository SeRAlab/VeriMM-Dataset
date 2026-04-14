module LoadableCounter (
    input clk,
    input reset,
    input load,
    input [5:0] load_value,
    output reg [5:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 6'b000000;
        else if (load)
            count <= load_value;
        else
            count <= count + 1;
    end
endmodule