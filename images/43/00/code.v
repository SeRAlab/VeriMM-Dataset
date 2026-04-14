module top_module(LO, I0, I1);parameter INIT = 4'h0;

    input I0, I1;

    output LO;

    reg  LO;
    wire [1:0] s;

    assign s = {I1, I0};

    always @(s)
       if ((s[1]^s[0] ==1) || (s[1]^s[0] ==0))
           LO = INIT[s];
         else if ((INIT[0] == INIT[1]) && (INIT[2] == INIT[3]) && (INIT[0] == INIT[2])) 
           LO = INIT[0];
         else if ((s[1] == 0) && (INIT[0] == INIT[1]))
           LO = INIT[0];
         else if ((s[1] == 1) && (INIT[2] == INIT[3])) 
           LO = INIT[2];
         else if ((s[0] == 0) && (INIT[0] == INIT[2])) 
           LO = INIT[0];
         else if ((s[0] == 1) && (INIT[1] == INIT[3]))
           LO = INIT[1];
         else
           LO = 1'bx;endmodule