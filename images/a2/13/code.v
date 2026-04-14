module top_module(
    input CLK,
    input RESET,
    input AS20,
    input DS20,
    input RW20,
    input [31:0] A,
    output [31:0] D_OUT,
    input [1:0] SIZ,
    output [1:0] DSACK,
    output RAMOE,
    output [1:0] RAS,
    output [3:0] CAS,
    inout [31:0] D
);wire [31:0] addr = A[23:0];
wire [1:0] byte_sel = A[1:0];

assign D_OUT = {D[31:24], D[23:16], D[15:8], D[7:0]};

assign RAS = {addr[20], addr[19]};
assign CAS = {addr[18], addr[17], addr[16], byte_sel};

assign DSACK = 2'b11;

assign RAMOE = 1'b1;

// Declare D as a reg type to allow value assignments
reg [31:0] D_reg;

assign D = (AS20 && DS20 && !RW20) ? 
            (SIZ == 2'b00 ? {24'hzzzzzz, D_OUT[7:0]} :
            (SIZ == 2'b01 ? {16'hzzzz, D_OUT[15:0]} :
            (SIZ == 2'b10 ? D_OUT : 32'hzzzzzzzz)))
            : 32'hzzzzzzzz;

// You can retain the output side if needed
assign D = D_reg;

// Update values based on clock or reset
always @(posedge CLK) begin
    if (RESET) begin
        D_reg <= 32'hzzzzzzzz;
    end else if (AS20 && DS20 && !RW20) begin
        case (SIZ)
            2'b00: D_reg <= {24'hzzzzzz, D_OUT[7:0]};
            2'b01: D_reg <= {16'hzzzz, D_OUT[15:0]};
            2'b10: D_reg <= D_OUT;
            default: D_reg <= 32'hzzzzzzzz;
        endcase
    end
end

endmodule