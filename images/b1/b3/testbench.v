`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    reg d;
    reg e;
    reg f;
    reg g;
    reg h;
    reg i;
    reg j;
    reg k;
    reg l;
    reg m;
    reg n;
    reg o;
    reg p;
    reg [3:0] sel;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .f(f),
        .g(g),
        .h(h),
        .i(i),
        .j(j),
        .k(k),
        .l(l),
        .m(m),
        .n(n),
        .o(o),
        .p(p),
        .sel(sel),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Select 'a' (sel=0) with signal 1", test_num);
        {a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p} = 16'h0000;
        a = 1'b1;
        sel = 4'd0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Select 'a' (sel=0) with signal 0", test_num);
        {a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p} = 16'hFFFF;
        a = 1'b0;
        sel = 4'd0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Select 'b' (sel=1) with signal 1", test_num);
        {a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p} = 16'h0000;
        b = 1'b1;
        sel = 4'd1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Select 'h' (sel=7) with signal 1", test_num);
        {a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p} = 16'h0000;
        h = 1'b1;
        sel = 4'd7;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Select 'i' (sel=8) with signal 1", test_num);
        {a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p} = 16'h0000;
        i = 1'b1;
        sel = 4'd8;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Select 'p' (sel=15) with signal 1", test_num);
        {a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p} = 16'h0000;
        p = 1'b1;
        sel = 4'd15;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Select 'p' (sel=15) with signal 0 while others are 1", test_num);
        {a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p} = 16'hFFFF;
        p = 1'b0;
        sel = 4'd15;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Mid-range selection 'e' (sel=4) check", test_num);
        {a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p} = 16'h0000;
        e = 1'b1;
        sel = 4'd4;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Mid-range selection 'l' (sel=11) check", test_num);
        {a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p} = 16'h0000;
        l = 1'b1;
        sel = 4'd11;
        #1;

        check_outputs(1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

endmodule
