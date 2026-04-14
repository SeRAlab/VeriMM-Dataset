module pcie_endpoint_controller (
    input wire clk,
    input wire reset,
    input wire read_enable,
    input wire [3:0] address,
    output reg [7:0] data_out
);

    reg [7:0] memory [0:15]; // 16 bytes of memory

    initial begin
        memory[0] = 8'hAA; // Sample data
        memory[1] = 8'hBB;
        memory[2] = 8'hCC;
        memory[3] = 8'hDD;
        memory[4] = 8'hEE;
        memory[5] = 8'hFF;
        memory[6] = 8'h00;
        memory[7] = 8'h11;
        memory[8] = 8'h22;
        memory[9] = 8'h33;
        memory[10] = 8'h44;
        memory[11] = 8'h55;
        memory[12] = 8'h66;
        memory[13] = 8'h77;
        memory[14] = 8'h88;
        memory[15] = 8'h99;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'h00;
        end else if (read_enable) begin
            data_out <= memory[address];
        end
    end
endmodule