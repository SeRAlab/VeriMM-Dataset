module binary_counter2bit (
    input clk,
    output reg [1:0] count
);

    always_ff @(posedge clk) begin
        count <= count + 1;
    end

endmodule