module sync_counter_with_load (
    input clk,
    input load,
    input [3:0] d,
    output reg [3:0] count
);

    always @(posedge clk) begin
        if (load) begin
            count <= d;
        end else begin
            count <= count + 1;
        end
    end

endmodule