module up_counter_with_load (
    input clk,
    input en,
    input load,
    input [7:0] load_value,
    output reg [7:0] count);

    always @(posedge clk) begin
        if (load) begin
            count <= load_value;
        end else if (en) begin
            count <= count + 1;
        end
    end
endmodule