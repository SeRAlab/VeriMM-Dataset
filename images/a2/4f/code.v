module top_module(
    input CLK,
    input RESET,
    input SHIFT,
    input LOAD,
    input [3:0] DATA,
    input [3:0] D,
    output reg [3:0] Q
);reg [3:0] shift_reg;
reg [3:0] counter;
wire [3:0] xor_out;

// Shift register module
always @(posedge CLK) begin
    if(RESET) begin
        shift_reg <= 4'b0000;
    end
    else if(SHIFT) begin
        shift_reg <= {shift_reg[2:0], counter[0]};
    end
end

// Synchronous counter module
always @(posedge CLK) begin
    if(RESET) begin
        counter <= 4'b0000;
    end
    else if(LOAD) begin
        counter <= DATA;
    end
    else begin
        counter <= counter + 1;
    end
end

// XOR module
assign xor_out = shift_reg ^ counter;

// Output
always @(posedge CLK) begin
    if(RESET) begin
        Q <= 4'b0000;
    end
    else begin
        Q <= counter;
    end
end

endmodule