module top_module(
    input UD,
    input CLK,
    input RST,
    input LD,
    input [3:0] load_value,
    output reg [3:0] Q
);always @(posedge CLK) begin
        if (RST) begin
            Q <= 4'b0000;
        end else if (LD) begin
            Q <= load_value;
        end else if (UD) begin
            Q <= Q + 4'b0001;
        end else begin
            Q <= Q - 4'b0001;
        end
    end

endmodule