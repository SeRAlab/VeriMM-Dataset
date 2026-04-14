module top_module(
    input [1:0] address,
    input chipselect,
    input clk,
    input in_port,
    input reset_n,
    input write_n,
    input [31:0] writedata,
    output [31:0] readdata
);reg [31:0] readdata_reg;
    wire clk_en;
    reg d1_data_in;
    reg d2_data_in;
    wire data_in;
    reg edge_capture;
    wire edge_capture_wr_strobe;
    wire edge_detect;
    wire read_mux_out;
    
    assign clk_en = 1;
    
    //s1, which is an e_avalon_slave
    assign read_mux_out = ({1 {(address == 0)}} & data_in) |
        ({1 {(address == 3)}} & edge_capture);
    
    always @(posedge clk or negedge reset_n) begin
        if (reset_n == 0) begin
            readdata_reg <= 0;
        end else if (clk_en) begin
            readdata_reg <= {32'b0 | read_mux_out};
        end
    end
    
    assign data_in = in_port;
    assign edge_capture_wr_strobe = chipselect && ~write_n && (address == 3);
    
    always @(posedge clk or negedge reset_n) begin
        if (reset_n == 0) begin
            edge_capture <= 0;
        end else if (clk_en) begin
            if (edge_capture_wr_strobe) begin
                edge_capture <= 0;
            end else if (edge_detect) begin
                edge_capture <= -1;
            end
        end
    end
    
    always @(posedge clk or negedge reset_n) begin
        if (reset_n == 0) begin
            d1_data_in <= 0;
            d2_data_in <= 0;
        end else if (clk_en) begin
            d1_data_in <= data_in;
            d2_data_in <= d1_data_in;
        end
    end
    
    assign edge_detect = d1_data_in & ~d2_data_in;
    
    assign readdata = readdata_reg;
    
endmodule