module top_module(
	       
	       i_rstb, i_spi_active, vi_data_rx, i_rx_valid, vi_byte_num,
	       
	       
	       
	       
	       
	       
	       
	       vio_data_spi);input 	i_rstb;
  
  input 	i_spi_active;
  input [7:0] 	vi_data_rx;
  input 	i_rx_valid;
  input [2:0] 	vi_byte_num;
  
  inout [7:0] 	vio_data_spi;
  
  
  
  
  
  
  
  reg [7:0] 	r_data_to_send;
  
  wire active = i_rstb && i_spi_active;
  
  reg [7:0] 	rv_opcode;
  reg 		r_read_map;
  reg 		r_write_map;
  reg [7:0] 	rv_addr;
  always @( posedge i_rx_valid or negedge active ) begin : opcode_fsm
    if ( !active ) begin
      rv_opcode <= 0;
      r_read_map <= 0;
      r_write_map <= 0;
      rv_addr <= 0;
    end else begin
      
      if ( 0 == vi_byte_num )
	rv_opcode <= vi_data_rx;
      
      if ( 1 == vi_byte_num )
	rv_addr <= vi_data_rx;
      
      if ( 1 == vi_byte_num ) begin
	if ( 32 == rv_opcode )
	  r_write_map <= 1;
	else
	  r_write_map <= 0;
	if ( 48 == rv_opcode )
	  r_read_map <= 1;
	else
	  r_read_map <= 0;
      end
    end 
  end 
  
  always @( posedge i_rx_valid or negedge i_rstb ) begin
    if ( !i_rstb ) begin
      
    end else begin
      
    end
  end 
  
  
  always @( posedge i_rx_valid or negedge active ) begin
    if ( !active ) begin
      
    end else begin
      if (( 2 == vi_byte_num ) && (r_write_map )) begin
	
      end
    end
  end
  
  
  
  
  
  always @( posedge i_rx_valid or negedge active ) begin
    if ( !active ) begin
      r_data_to_send <= 0;
    end else begin
      
    end
  end
  
  assign vio_data_spi = r_read_map ? r_data_to_send : 8'bz;
endmodule