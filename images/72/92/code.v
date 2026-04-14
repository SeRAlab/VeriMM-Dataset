module binary_counter_with_load (
    input clk,
    input reset,
    input load,
    input [3:0] load_val,
    output reg [3:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'b0000;
        end else if (load) begin
            count <= load_val;
        end else begin
            count <= count + 1;
        end
    end

endmodule