module top_module(input IN1, IN2, IN3, IN4, output Q, input S0, S1, VDD, VSS);wire AND1, AND2, AND3, AND4, NOT1, NOT2;
    assign NOT1 = ~S0;
    assign NOT2 = ~S1;
    assign AND1 = IN1 & NOT1 & NOT2;
    assign AND2 = IN2 & NOT1 & S1;
    assign AND3 = IN3 & S0 & NOT2;
    assign AND4 = IN4 & S0 & S1;
    assign Q = AND1 | AND2 | AND3 | AND4;
endmodule