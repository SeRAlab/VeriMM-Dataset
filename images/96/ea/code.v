module top_module(
    input clk,
    input xmit,
    input recv,
    input [7:0] tx,
    output reg [7:0] rx
);reg [7:0] tx_reg;
reg [3:0] bit_count;
reg xmit_bit_shift; // Changed from xmit_bit to xmit_bit_shift

wire start_bit;
wire stop_bit;

// Use an additional reg to store the xmit_bit
reg xmit_bit;

assign start_bit = (bit_count == 0);
assign stop_bit = (bit_count == 9);

// Modify tx sending logic
always @(posedge clk) begin
    if (xmit) begin
        if (start_bit) begin
            tx_reg <= tx;
            bit_count <= 1;
            xmit_bit <= 0;
        end else if (stop_bit) begin
            xmit_bit <= 1;
            bit_count <= 0;
        end else begin
            xmit_bit <= tx_reg[0]; // Continue to assign the bit to xmit_bit
            tx_reg <= {tx_reg[6:0], 1'b0};
            bit_count <= bit_count + 1;
        end
    end else begin
        bit_count <= 0;
    end
end

// Modify rx receiving logic
always @(posedge clk) begin
    if (recv) begin
        if (start_bit) begin
            rx <= 0;
            bit_count <= 1;
        end else if (stop_bit) begin
            bit_count <= 0;
        end else begin
            rx <= {rx[6:0], recv};
            bit_count <= bit_count + 1;
        end
    end else begin
        bit_count <= 0;
    end
end

// Removed the problematic xmit_bit assignment as it was not necessary
// Changed the final assignment of rx
// This assign statement was attempting to continuously drive rx with high impedance,
// which isn't valid for registered outputs
// This doesn't need to be assigned; rx is already set in the recv block
// assign rx = (bit_count == 9) ? rx : 8'hZZ; // Remove this line

endmodule