`timescale 1ns/1ps

module mux_8to1_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    reg d;
    reg e;
    reg f;
    reg g;
    reg h;
    reg [2:0] sel;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_8to1 dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .f(f),
        .g(g),
        .h(h),
        .sel(sel),
        .y(y)
    );
    task testcase001;

    begin
        test_num = 1;
        {a, b, c, d, e, f, g, h} = 8'b1000_0000; sel = 3'b000;
        $display("Testcase %0d: Select input a (a=1, sel=000)", test_num);
        #1;

        check_outputs(1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        {a, b, c, d, e, f, g, h} = 8'b0100_0000; sel = 3'b001;
        $display("Testcase %0d: Select input b (b=1, sel=001)", test_num);
        #1;

        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        {a, b, c, d, e, f, g, h} = 8'b0010_0000; sel = 3'b010;
        $display("Testcase %0d: Select input c (c=1, sel=010)", test_num);
        #1;

        check_outputs(1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        {a, b, c, d, e, f, g, h} = 8'b0001_0000; sel = 3'b011;
        $display("Testcase %0d: Select input d (d=1, sel=011)", test_num);
        #1;

        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        {a, b, c, d, e, f, g, h} = 8'b0000_1000; sel = 3'b100;
        $display("Testcase %0d: Select input e (e=1, sel=100)", test_num);
        #1;

        check_outputs(1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        {a, b, c, d, e, f, g, h} = 8'b0000_0100; sel = 3'b101;
        $display("Testcase %0d: Select input f (f=1, sel=101)", test_num);
        #1;

        check_outputs(1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        {a, b, c, d, e, f, g, h} = 8'b0000_0010; sel = 3'b110;
        $display("Testcase %0d: Select input g (g=1, sel=110)", test_num);
        #1;

        check_outputs(1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        {a, b, c, d, e, f, g, h} = 8'b0000_0001; sel = 3'b111;
        $display("Testcase %0d: Select input h (h=1, sel=111)", test_num);
        #1;

        check_outputs(1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        {a, b, c, d, e, f, g, h} = 8'b1111_0111; sel = 3'b100;
        $display("Testcase %0d: Select input e (e=0, others=1, sel=100)", test_num);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        {a, b, c, d, e, f, g, h} = 8'b0111_1111; sel = 3'b000;
        $display("Testcase %0d: Select input a (a=0, others=1, sel=000)", test_num);
        #1;

        check_outputs(0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_8to1 Testbench");
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
        testcase010();
        
        
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
        input expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%b",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%b",
                         expected_y);
                $display("  Got:      y=%b",
                         y);
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
