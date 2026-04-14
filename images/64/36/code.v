module top_module(
    clk_in,
    RST,
    ctrl_in,
    data,
    addr,
    data_out,
    addr_out,
    en_out
);parameter CTRL_WIDTH = 4; // width of control signal
parameter DATA_WIDTH = 16; // width of data signal
parameter REG_ADDR_WIDTH = 8; // width of register address

// input / output
input clk_in, RST;
input [CTRL_WIDTH-1:0] ctrl_in;
input signed [DATA_WIDTH-1:0] data;
input [REG_ADDR_WIDTH-1:0] addr;

output reg signed [DATA_WIDTH-1:0] data_out;
output reg [REG_ADDR_WIDTH-1:0] addr_out;
output reg en_out;

// Control signal definitions
localparam LW      = 4'b0001; // Load Word
localparam LW_IMM  = 4'b0010; // Load Word Immediate
localparam ADD     = 4'b0011; // Add
localparam SUB     = 4'b0100; // Subtract
localparam MUL     = 4'b0101; // Multiply
localparam DIV     = 4'b0110; // Divide
localparam AND     = 4'b0111; // AND
localparam OR      = 4'b1000; // OR
localparam NOT     = 4'b1001; // NOT

// repasse dos enderecos data e addr
always @(posedge clk_in) begin
    data_out <= data;
    addr_out <= addr;
end

// execucao da gravacao nos registradores
always @(posedge clk_in) begin
    if (!RST) begin
        // rotina de reset
        en_out    <= 0;
    end else begin
        // Case para controle de habilitação de escrita no registrador de acordo com o opcode de entrada.
        case (ctrl_in)
        // ------------ Data Transfer -----------------
        LW:       en_out <= 1;
        LW_IMM:   en_out <= 1;
        // ------------ Arithmetic -----------------
        ADD:      en_out <= 1;
        SUB:      en_out <= 1;
        MUL:      en_out <= 1;
        DIV:      en_out <= 1;
        // ------------ Logic -----------------
        AND:      en_out <= 1;
        OR :      en_out <= 1;
        NOT:      en_out <= 1;
        // ------------ Control Transfer -----------------
        // All default
        default:  en_out <= 0;
        endcase
     end
end

endmodule