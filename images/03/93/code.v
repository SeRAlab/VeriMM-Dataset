module NVMeCommandRegister (
    input wire clk,
    input wire we,         // write enable
    input wire [31:0] cmd_input,
    output reg [31:0] cmd_output
);
    
    always @(posedge clk) begin
        if (we) begin
            cmd_output <= cmd_input; // update command on write enable
        end
    end

endmodule