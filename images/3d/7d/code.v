module counter_8bit (
    input clk,
    input reset,
    input load,
    input [7:0] load_value,
    output reg [7:0] count
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 8'b0;
        end else if (load) begin
            count <= load_value;
        end else begin
            count <= (count == 8'b11111111) ? 8'b0 : count + 1;
        end
    end
endmodule