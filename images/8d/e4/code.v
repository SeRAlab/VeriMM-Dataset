module parallel_load_counter (
    input clk,
    input reset,
    input load,
    input [6:0] data,
    output reg [6:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 7'b0000000;
        end else if (load) begin
            count <= data;
        end else begin
            count <= count + 7'b0000001;
        end
    end
endmodule