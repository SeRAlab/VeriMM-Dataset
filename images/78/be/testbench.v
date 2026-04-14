`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg g;
    reg h;
    reg i;
    reg j;
    wire f;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .g(g),
        .h(h),
        .i(i),
        .j(j),
        .f(f)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: g=1, h=0, i=0, j=1", test_num);
        g = 1'b1; h = 1'b0; i = 1'b0; j = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: g=1, h=1, i=0, j=0", test_num);
        g = 1'b1; h = 1'b1; i = 1'b0; j = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: g=0, h=1, i=1, j=0", test_num);
        g = 1'b0; h = 1'b1; i = 1'b1; j = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: g=1, h=0, i=1, j=1", test_num);
        g = 1'b1; h = 1'b0; i = 1'b1; j = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: g=1, h=1, i=1, j=0", test_num);
        g = 1'b1; h = 1'b1; i = 1'b1; j = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: g=0, h=0, i=1, j=1", test_num);
        g = 1'b0; h = 1'b0; i = 1'b1; j = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: g=1, h=0, i=1, j=0", test_num);
        g = 1'b1; h = 1'b0; i = 1'b1; j = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: g=0, h=0, i=0, j=0", test_num);
        g = 1'b0; h = 1'b0; i = 1'b0; j = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %03d: g=0, h=1, i=0, j=1", test_num);
        g = 1'b0; h = 1'b1; i = 1'b0; j = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %03d: g=0, h=0, i=0, j=1", test_num);
        g = 1'b0; h = 1'b0; i = 1'b0; j = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Testcase %03d: g=1, h=1, i=1, j=1", test_num);
        g = 1'b1; h = 1'b1; i = 1'b1; j = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Testcase %03d: g=0, h=1, i=0, j=0", test_num);
        g = 1'b0; h = 1'b1; i = 1'b0; j = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("Testcase %03d: g=1, h=1, i=0, j=1", test_num);
        g = 1'b1; h = 1'b1; i = 1'b0; j = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        $display("Testcase %03d: g=1, h=0, i=0, j=0", test_num);
        g = 1'b1; h = 1'b0; i = 1'b0; j = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        $display("Testcase %03d: g=0, h=1, i=1, j=1", test_num);
        g = 1'b0; h = 1'b1; i = 1'b1; j = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        $display("Testcase %03d: g=0, h=0, i=1, j=0", test_num);
        g = 1'b0; h = 1'b0; i = 1'b1; j = 1'b0;
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
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input expected_f;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_f === (expected_f ^ f ^ expected_f)) begin
                $display("PASS");
                $display("  Outputs: f=%b",
                         f);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: f=%b",
                         expected_f);
                $display("  Got:      f=%b",
                         f);
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
