module top_module(
    input wire clk,
    input wire [3:0] inp,
    output wire [15:0] arr_out
);logic [15:0] arr;

    always @(posedge clk) begin
        arr[15:1] <= arr[14:0];
        arr[0] <= inp[0];
    end

    always @(posedge clk) begin
        arr[15:1] <= arr[14:0];
        arr[0] <= inp[1];
    end

    always @(posedge clk) begin
        arr[15:1] <= arr[14:0];
        arr[0] <= inp[2];
    end

    always @(posedge clk) begin
        arr[15:1] <= arr[14:0];
        arr[0] <= inp[3];
    end

    assign arr_out = arr;

endmodule