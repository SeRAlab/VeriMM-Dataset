module timer (
    input wire clk,
    input wire reset,
    input wire load,
    input wire [7:0] preset_value,
    output reg [7:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 8'b0;
        end else if (load) begin
            count <= preset_value;
        end else begin
            count <= count + 1;
        end
    end
endmodule