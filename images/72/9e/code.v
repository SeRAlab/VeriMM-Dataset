module top_module(
    input clk,
    input [1:0] in1,
    input [1:0] in2,
    input select,
    output reg [3:0] out // Change wire to reg for procedural assignment
);wire [3:0] decoder1_out;
    wire [3:0] decoder2_out;
    wire [3:0] binary_out;
    
    // Decoder 1 implementation using AND, OR, and NOT gates
    assign decoder1_out[0] = ~(in1[1] & in1[0]);
    assign decoder1_out[1] = ~(in1[1] & ~in1[0]);
    assign decoder1_out[2] = ~(~in1[1] & in1[0]);
    assign decoder1_out[3] = ~(~in1[1] & ~in1[0]);
    
    // Decoder 2 implementation using AND, OR, and NOT gates
    assign decoder2_out[0] = ~(in2[1] & in2[0]);
    assign decoder2_out[1] = ~(in2[1] & ~in2[0]);
    assign decoder2_out[2] = ~(~in2[1] & in2[0]);
    assign decoder2_out[3] = ~(~in2[1] & ~in2[0]);
    
    // Binary output implementation
    assign binary_out[0] = in1[0] & in2[0];
    assign binary_out[1] = in1[0] & in2[1];
    assign binary_out[2] = in1[1] & in2[0];
    assign binary_out[3] = in1[1] & in2[1];
    
    // Control logic to select active module
    always @ (posedge clk) begin // Triggered on the rising edge of the clock
        if (select == 0) begin
            out <= decoder1_out;
        end else if (select == 1) begin
            out <= decoder2_out;
        end else begin
            out <= binary_out;
        end
    end
    
endmodule