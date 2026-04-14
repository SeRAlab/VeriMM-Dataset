module pipeline_register (
    input clk,
    input [31:0] instruction_in,
    input [4:0] control_in,
    output reg [31:0] instruction_out,
    output reg [4:0] control_out
);
    
    always @(posedge clk) begin
        instruction_out <= instruction_in;
        control_out <= control_in;
    end

endmodule