module up_counter_with_load(
    input clk,
    input reset,
    input load,
    input [4:0] load_value,
    output reg [4:0] count
    );

    always @(posedge clk) begin
        if (reset) begin
            count <= 5'b00000;
        end else if (load) begin
            count <= load_value;
        end else begin
            count <= count + 1;
        end
    end
endmodule