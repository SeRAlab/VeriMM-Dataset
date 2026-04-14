module top_module(
    input [7:0] addr,
    input [7:0] data_in,
    input write_enable,
    input [15:0] addr16,
    output reg [7:0] data_out1,
    output reg [7:0] data_out2,
    output reg [7:0] data_out3,
    output reg [7:0] data_out4
);reg [7:0] data1;
reg [7:0] data2;
reg [7:0] data3;
reg [7:0] data4;

always @ (addr) begin
    case (addr)
        8'h11    : data1 = data_in;
        8'h22    : data2 = data_in;
        default : 
            if(write_enable)
                $display("Invalid address");
    endcase
end

always @ (addr) begin
    case (addr)
        8'h11    : data_out1 = data1;
        8'h22    : data_out1 = data2;
        default : data_out1 = 8'h00;
    endcase
end

always @ (addr) begin
    case (addr)
        8'h11    : data_out2 = data1;
        8'h22    : data_out2 = data2;
        default : data_out2 = 8'h00;
    endcase
end

always @ (addr16) begin
    case (addr16)
        16'h0011 : data3 = data_in;
        16'h0022 : data4 = data_in;
        default : 
            if(write_enable)
                $display("Invalid address");
    endcase
end

always @ (addr16) begin
    case (addr16)
        16'h0011 : data_out3 = data3;
        16'h0022 : data_out3 = data4;
        default : data_out3 = 8'h00;
    endcase
end

always @ (addr) begin
    case ({addr[7:0], 1'b0})
        8'h11   : data_out4 = data1;
        8'h22   : data_out4 = data2;
        default : data_out4 = 8'h00;
    endcase
end

endmodule