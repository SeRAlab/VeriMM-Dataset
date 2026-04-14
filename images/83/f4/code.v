module top_module( 
     input   wire         reset,       //Active Hi
     input   wire         clock,       //System clock, should be synchronous with WcaRegbus
     input   wire         enableIn,    //Allows input if specified.
     input   wire  [31:0] in, 
     
   //Internal Interface.
    input   wire  [11:0] rbusCtrl,  // Address and control lines(12 total) { addr[7:0], readEnable, writeEnable, dataStrobe, clkbus}
    inout   wire  [7:0]  rbusData    // Tri-state I/O data.
     
);parameter my_addr = 0;

    wire [7:0] Q0;
    wire [7:0] Q1;
    wire [7:0] Q2;
    wire [7:0] Q3;

    wire addrValid = (my_addr == rbusCtrl[11:4]);
    wire read      = addrValid & rbusCtrl[3];
    wire enable    = enableIn & addrValid; // Corrected: Remove the negation on addrValid.

    // Count register for 4 pulse read.
    reg [1:0] select;
    always @(posedge rbusCtrl[0])
    begin
        if( reset | ~addrValid)
            select <= 2'h0;
        else if(rbusCtrl[1] & addrValid) 
            select <= select + 2'h1;
    end

    // Ensure WcaRegCore8 is defined elsewhere or replaced with appropriate functionality
    reg [7:0] sr [3:0]; // Temporary registers to replace WcaRegCore8 behavior

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            sr[0] <= 8'b0;
            sr[1] <= 8'b0;
            sr[2] <= 8'b0;
            sr[3] <= 8'b0;
        end else if (enable) begin
            sr[0] <= in[7:0];
            sr[1] <= in[15:8];
            sr[2] <= in[23:16];
            sr[3] <= in[31:24];
        end
    end

    //Place data on the bus if reading.
    assign rbusData = (read & select == 2'h0) ? sr[0] : 
                      (read & select == 2'h1) ? sr[1] : 
                      (read & select == 2'h2) ? sr[2] : 
                      (read & select == 2'h3) ? sr[3] : 8'bz;
      
endmodule