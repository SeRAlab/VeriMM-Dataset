module top_module(input c, r, w, input [7:0] wdata, output reg ce = 0);reg [7:0] count = 0;
   reg [7:0] div = 4;
   always @ (posedge c)
     begin
        if(w)
          div <= wdata;
        if(r || (count >= div))
          count <= 1'b0;
        else
          count <= count + 1'b1;
        ce <= !r && (count >= div);
     end
endmodule