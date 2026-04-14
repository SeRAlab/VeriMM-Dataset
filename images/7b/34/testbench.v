`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] a;
    reg [255:0] b;
    reg [255:0] d;
    reg [255:0] e;
    reg [255:0] f;
    wire [255:0] c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .d(d),
        .e(e),
        .f(f),
        .c(c)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select b (a=00)", test_num);
            a = 2'b00;
            b = 256'hAAAA_AAAA_BBBB_BBBB_CCCC_CCCC_DDDD_DDDD_EEEE_EEEE_FFFF_FFFF_0000_1111_2222_3333;
            d = 256'h0;
            e = 256'h0;
            f = 256'h0;
            #1;

            check_outputs(b);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select d (a=01)", test_num);
            a = 2'b01;
            b = 256'h0;
            d = 256'h1234_5678_9ABC_DEF0_1234_5678_9ABC_DEF0_1234_5678_9ABC_DEF0_1234_5678_9ABC_DEF0;
            e = 256'h0;
            f = 256'h0;
            #1;

            check_outputs(d);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select e (a=10)", test_num);
            a = 2'b10;
            b = 256'h0;
            d = 256'h0;
            e = 256'hFEDC_BA98_7654_3210_FEDC_BA98_7654_3210_FEDC_BA98_7654_3210_FEDC_BA98_7654_3210;
            f = 256'h0;
            #1;

            check_outputs(e);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select f (a=11)", test_num);
            a = 2'b11;
            b = 256'h0;
            d = 256'h0;
            e = 256'h0;
            f = 256'hDEAD_BEEF_CAFE_BABE_DEAD_BEEF_CAFE_BABE_DEAD_BEEF_CAFE_BABE_DEAD_BEEF_CAFE_BABE;
            #1;

            check_outputs(f);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs populated, select b", test_num);
            a = 2'b00;
            b = {128{2'b10}};
            d = {128{2'b01}};
            e = {64{4'hA}};
            f = {64{4'h5}};
            #1;

            check_outputs(b);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs populated, select e", test_num);
            a = 2'b10;
            b = {128{2'b10}};
            d = {128{2'b01}};
            e = {64{4'hA}};
            f = {64{4'h5}};
            #1;

            check_outputs(e);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs 0, select d", test_num);
            a = 2'b01;
            b = 256'h0;
            d = 256'h0;
            e = 256'h0;
            f = 256'h0;
            #1;

            check_outputs(256'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs FF, select f", test_num);
            a = 2'b11;
            b = {256{1'b1}};
            d = {256{1'b1}};
            e = {256{1'b1}};
            f = {256{1'b1}};
            #1;

            check_outputs({256{1'b1}});
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
        input [255:0] expected_c;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c === (expected_c ^ c ^ expected_c)) begin
                $display("PASS");
                $display("  Outputs: c=%h",
                         c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h",
                         expected_c);
                $display("  Got:      c=%h",
                         c);
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
