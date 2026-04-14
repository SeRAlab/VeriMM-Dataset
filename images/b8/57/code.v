module counter_4bit_sync (
    input wire clk,
    input wire rst,
    output wire [3:0] count
);

    wire [1:0] count_0, count_1;

    counter_2bit_sync counter_2bit_sync_inst1 (
        .clk(clk),
        .rst(rst),
        .count(count[3:2])
    );

    counter_2bit_sync counter_2bit_sync_inst2 (
        .clk(clk),
        .rst(rst),
        .count(count[1:0])
    );

endmodule

module counter_2bit_sync (
    input wire clk,
    input wire rst,
    output reg [1:0] count
);

    always @(posedge clk) begin
        if (rst)
            count <= 2'b00;
        else
            count <= count + 1;
    end

endmodule