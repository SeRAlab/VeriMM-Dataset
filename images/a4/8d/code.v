module top_module(
    input clk,
    input rst,
    output reg [3:0] count
);// Module supplies
    supply1 VPWR;
    supply0 VGND;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 4'b0;
        end else begin
            count <= count + 4'b1;
            if (count == 4'b1111) begin
                count <= 4'b0;
            end
        end
    end
    
    // The mux2_1 module is not available. 
    // Below is a simple implementation of a 2-to-1 multiplexer instead.
    wire mux_out;
    wire [3:0] mux_A = 4'b0; // Input A
    wire [3:0] mux_B = count; // Input B
    wire mux_S = count[0]; // Selector
    
    assign mux_out = (mux_S) ? mux_B : mux_A; // 2-to-1 mux implementation
    
endmodule