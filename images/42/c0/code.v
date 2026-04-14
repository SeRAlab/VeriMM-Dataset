module top_module(
    output reg [7:0] reg_0x15, 
    input wire reset, 
    input wire wenb, 
    input wire [7:0] in_data, 
    input wire clk
);always @(posedge clk) begin
    if (reset) begin
        reg_0x15 <= 8'h00;
    end
    else begin
        if (wenb == 0) begin
            reg_0x15 <= in_data;
        end
    end
end

endmodule