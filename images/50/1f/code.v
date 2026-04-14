module top_module(
    input CLK,
    input PIN_14,
    output LED,
    output USBPU  
);assign USBPU = 0;

    reg [23:0] counter;         
    reg active;

    always @(posedge CLK) begin
      if (1 == &counter) begin
        active <= ~active;      
        counter <= 0;
      end else begin
        counter <= counter + 1;
      end
    end

    assign LED = PIN_14 & active;        
endmodule