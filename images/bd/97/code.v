module top_module(
    input wire clk50,
    input wire rst,
    
    //Input
    //Control
    input wire[2:0] ramOp_i,
    input wire[31:0] storeData_i,
    input wire[21:0] ramAddr_i,
    
    //Data from SRAM
    input wire[31:0] ramData_i,
    
    //Output
    //Control
    output wire[21:0] ramAddr_o,
    output wire sramEnable_o,
    output wire writeEnable_o,
    output wire busEnable_o,
    output wire[31:0] writeData_o,
    output wire readEnable_o,
    
    //Data to MMU
    output wire[31:0] ramData_o
    
    );reg[2:0] state;
    
    //Control
    assign sramEnable_o = ~rst;
    assign readEnable_o = (state == 2'b01 || state == 2'b10);
    assign writeEnable_o = (state == 2'b01);
    assign busEnable_o = (state == 2'b01 || state == 2'b10);
    
    //Address & Data
    assign writeData_o = storeData_i;
    assign ramData_o = readEnable_o ? ramData_i : 32'h0;
    assign ramAddr_o = (state == 2'b00) ? 22'h0 : ramAddr_i;
    
    //State machine
    always @(posedge clk50) begin
        if (rst == 1'b1) begin
            state <= 2'b00;
        end else if (state == 2'b01) begin
            state <= 2'b10;
        end else if (state == 2'b10) begin
            state <= 2'b00;
        end else if (ramOp_i == 3'b001) begin
            state <= 2'b01;
        end else if (ramOp_i == 3'b010) begin
            state <= 2'b01;
        end else begin
            state <= 2'b00;
        end
    end
    
endmodule