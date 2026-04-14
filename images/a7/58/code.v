module top_module(
    input clk,
    input reset,   // Synchronous active-high reset
    input [7:0] d1, // 8-bit input for the first register
    input [7:0] d2, // 8-bit input for the second register
    input select, // Select input to choose between the two registers and the counter
    output [7:0] q_active, // 8-bit output from the active module
    output [15:0] result // 16-bit output from the functional module
);reg [7:0] reg1, reg2;
reg [3:0] counter;
wire [7:0] active_module_out;

assign active_module_out = (select) ? ((select == 1) ? reg1 : reg2) : counter;

always @(posedge clk) begin
    if (reset) begin
        reg1 <= 8'h34;
        reg2 <= 8'h34;
        counter <= 4'b0;
    end else begin
        case (select)
            1: reg1 <= d1;
            2: reg2 <= d2;
            3: counter <= (counter == 4'b1111) ? 4'b0 : counter + 1;
        endcase
    end
end

assign q_active = active_module_out;

assign result = {reg1, reg2} + 16'b0;

endmodule