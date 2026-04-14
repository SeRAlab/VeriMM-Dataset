module top_module(
    input clock,
    input clock_debug,
    input reset,
    input WriteEnable,
    input [4:0] read_address_1,
    input [4:0] read_address_2,
    input [4:0] read_address_3,
    input [31:0] write_data_in,
    input [4:0] write_address,
    input [4:0] read_address_debug,
    output [31:0] data_out_1,
    output [31:0] data_out_2,
    output [31:0] data_out_3,
    output [31:0] data_out_debug);reg [31:0] i;
    
    //Array of 32 registers
    reg [31:0] register[0:31];
 
    assign data_out_1 = ( read_address_1 == 0 ) ? 32'b0 : register[read_address_1]; 
    assign data_out_2 = ( read_address_2 == 0 ) ? 32'b0 : register[read_address_2]; 
    assign data_out_3 = ( read_address_3 == 0 ) ? 32'b0 : register[read_address_3];
    assign data_out_debug = ( read_address_debug == 0 ) ? 32'b0 : register[read_address_debug];
    
    //Write only on rising edge of clock and WriteEnable is high and reset if reset is high
    always @(posedge clock) begin
        if(WriteEnable &&(write_address != 5'b0))begin
            register[write_address] <= write_data_in;
        end
        if(reset)begin
            for(i=0;i<32;i=i+1)begin
                register[i] = 0;
            end
        end
    end
    
    
endmodule