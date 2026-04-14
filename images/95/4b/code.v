module top_module(
                                        
                                         data,
                                         rdaddress,
                                         rdclken,
                                         wraddress,
                                         wrclock,
                                         wren,

                                        
                                         q
                                      )
;output  [ 31: 0] q;
  input   [ 31: 0] data;
  input   [ 23: 0] rdaddress;
  input            rdclken;
  input   [ 23: 0] wraddress;
  input            wrclock;
  input            wren;

  reg     [ 31: 0] mem_array [16777215: 0];
  wire    [ 31: 0] q;
  reg     [ 23: 0] read_address;



  always @(rdaddress)
    begin
      read_address = rdaddress;
    end


  
  assign q = mem_array[read_address];

  always @(posedge wrclock)
    begin
      
      if (wren)
          mem_array[wraddress] <= data;
    end




































endmodule