module top_module(DataA0, DataA1, DataA2, DataA3,DataB0, DataB1, DataB2, DataB3,Result0, Result1, Result2, Result3, Cout);input DataA0, DataA1, DataA2, DataA3; 
 input DataB0, DataB1, DataB2, DataB3; 
 output Result0, Result1, Result2, Result3, Cout; 
 assign {Cout, Result3, Result2, Result1, Result0} = {DataA3, DataA2, DataA1, DataA0} + {DataB3, DataB2, DataB1, DataB0}; 
 endmodule