module top_module (
    input clk,
    input load,
    input [4:0] initial_value,
    output reg [4:0] count
);

    // 5-bit binary counter with loadable initial value logic
    always @(posedge clk) begin
        if (load) begin
            count <= initial_value;
        end else begin
            count <= count + 1;
        end
    end

endmodule