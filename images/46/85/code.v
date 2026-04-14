module top_module(
    input hclk, 
    input write,
    input [8:0] cpu_address, 
    input [7:0] cpu_data_in, 
    input pixclk,
    input [8:0] cur_address, 
    output reg [7:0] cur_data_out, 
    output reg [7:0] cpu_data_out
    );reg [7:0] ram_data [0:511];

    always @(posedge hclk) begin
        if (write) begin
            ram_data[cpu_address] <= cpu_data_in;
        end
    end

    always @(posedge pixclk) begin
        if (!write) begin
            cur_data_out <= ram_data[cur_address];
        end
    end

    assign cpu_data_out = ram_data[cpu_address];

endmodule