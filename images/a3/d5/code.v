module top_module(
    input clk,
    input [3:0] data_in,
    output [3:0] data_out
);reg [3:0] q; // Register to hold the shifted data

    always @(posedge clk) begin
        // Shift the input data into the register
        q <= {q[2:0], data_in[0]}; 
    end

    assign data_out = q;

endmodule