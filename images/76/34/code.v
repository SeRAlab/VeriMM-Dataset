module binary_counter (
    input clk,
    input load,
    input [3:0] data_in,
    output reg [3:0] count
);

    always @(posedge clk) begin
        if (load)
            count <= data_in;
        else
            count <= count + 1;
    end

endmodule