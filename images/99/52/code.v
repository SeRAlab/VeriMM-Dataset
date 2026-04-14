module top_module(
    input clk,
    input load,
    input up_down,
    input [3:0] D,
    output [3:0] OUT
);reg [3:0] up_counter;
reg [3:0] down_counter;
wire [3:0] xor_output;

// Up counter
always @(posedge clk) begin
    if (load) begin
        up_counter <= D;
    end else if (up_down) begin
        if (up_counter == 4'b1111) begin
            up_counter <= 4'b0;
        end else begin
            up_counter <= up_counter + 1;
        end
    end
end

// Down counter
always @(posedge clk) begin
    if (load) begin
        down_counter <= D;
    end else if (!up_down) begin
        if (down_counter == 4'b0000) begin
            down_counter <= 4'b1111;
        end else begin
            down_counter <= down_counter - 1;
        end
    end
end

// XOR module
assign xor_output = up_counter ^ down_counter;

// Output
assign OUT = xor_output;

endmodule