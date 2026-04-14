module top_module(load_not_db, load_db, load_adr, not_db, db, adr, b_out);input load_not_db;      
  input load_db;          
  input load_adr;         
  input [7:0] not_db;     
  input [7:0] db;         
  input [7:0] adr;        
  output reg [7:0] b_out; 

  always @(*)
    begin
      if (load_not_db)
        b_out <= not_db;
      else if (load_db)
        b_out <= db;
      else if (load_adr)
        b_out <= adr;
    end
endmodule