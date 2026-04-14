module top_module(
    input             read_n,
                      write_n,
                      ce_n,
    input      [6:0]  address_bus,
    inout      [7:0]  data_bus,

	inout      [7:0]  mem_data,
	output     [16:0] mem_address,
    output wire       ceh_n,
                      ce2,
                      we_n,
                      oe_n);assign mem_address[16:7] = 0;

	assign mem_address[6:0] = address_bus;

	

    
	assign data_bus = (~(ce_n | read_n | ~write_n)) ? mem_data : 8'bz;
    
    
	

    
    assign mem_data = (~(ce_n | write_n | ~read_n)) ? data_bus : 8'bz;

    
    
    

    assign ceh_n = 1'b0;
    assign ce2   = 1'b1;

    
    assign oe_n = (~(ce_n | read_n)) ? 1'b0 : 1'b1;

    
    assign we_n = (~(ce_n | write_n | ~read_n)) ? 1'b0 : 1'b1;

endmodule