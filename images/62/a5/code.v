module binary_counter_2bit(
    input wire clk,
    output reg [1:0] count
);

    always @(posedge clk) begin
        count <= count + 1;
    end

endmodule