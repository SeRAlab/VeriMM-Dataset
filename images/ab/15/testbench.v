`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [19:0] a;
    reg [19:0] b;
    reg [24:0] c;
    wire [24:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .z(z)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All zeros", test_num);
        a = 20'sd0; b = 20'sd0; c = 25'sd0;
        #1;

        check_outputs(25'sd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Small positive even values", test_num);
        a = 20'sd100; b = 20'sd200; c = 25'sd400;

        #1;


        check_outputs(25'sd500);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Small negative even values", test_num);
        a = 20'sd-100; b = 20'sd-200; c = 25'sd-400;

        #1;


        check_outputs(25'sd-500);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum positive a and b", test_num);
        a = 20'sd524287; b = 20'sd524287; c = 25'sd100;

        #1;


        check_outputs(25'sd1048624);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Minimum negative a and b", test_num);
        a = 20'sd-524288; b = 20'sd-524288; c = 25'sd-100;

        #1;


        check_outputs(25'sd-1048626);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Odd positive c (1)", test_num);
        a = 20'sd0; b = 20'sd0; c = 25'sd1;

        #1;


        check_outputs(25'sd1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Odd negative c (-1)", test_num);
        a = 20'sd0; b = 20'sd0; c = 25'sd-1;

        #1;


        check_outputs(25'sd-1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Large odd positive c", test_num);
        a = 20'sd0; b = 20'sd0; c = 25'sd16777215;

        #1;


        check_outputs(25'sd8388608);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mixed signs and odd negative c", test_num);
        a = 20'sd1000; b = 20'sd-500; c = 25'sd-3;

        #1;


        check_outputs(25'sd498);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Result approaching max range", test_num);
        a = 20'sd524287; b = 20'sd-524288; c = 25'sd16777215;

        #1;


        check_outputs(25'sd8388607);
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
        input [24:0] expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: z=%h",
                         z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: z=%h",
                         expected_z);
                $display("  Got:      z=%h",
                         z);
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
