module top_module(
    input [10:0] Data_In,
    input [3:0] Mutex_Addr_I_reg,
    input [31:23] Mutex_Wr_Data_I_reg,
    input Write_Strobe,
    input [1:0] Q,
    input S0_AXI_ACLK,
    output reg [8:0] D
);reg [1:0] current_channel;
reg [10:0] ram [0:3]; // Updated size if we assume we require only 4 channels

always @(posedge S0_AXI_ACLK) begin
    // Update the current channel based on Q input
    current_channel <= Q;

    // Write to RAM if Write_Strobe is high and correct address is selected
    if (Write_Strobe && (Mutex_Addr_I_reg[1:0] == current_channel)) begin
        ram[current_channel] <= Data_In;
    end

    // Read from RAM the lower 9 bits of the current channel
    D <= ram[current_channel][8:0];
end

endmodule