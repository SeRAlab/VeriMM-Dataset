`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [17:0] In1_im;
    reg [17:0] In1_re;
    reg [17:0] In2_im;
    reg [17:0] In2_re;
    wire [35:0] Im;
    wire [35:0] Re;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .In1_im(In1_im),
        .In1_re(In1_re),
        .In2_im(In2_im),
        .In2_re(In2_re),
        .Im(Im),
        .Re(Re)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Multiplication", test_num);
            In1_re = 18'sd0; In1_im = 18'sd0;
            In2_re = 18'sd0; In2_im = 18'sd0;
            #1;

            check_outputs(36'sd0, 36'sd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identity Multiplication", test_num);
            In1_re = 18'sd1; In1_im = 18'sd0;
            In2_re = 18'sd1; In2_im = 18'sd0;
            #1;

            check_outputs(36'sd0, 36'sd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Mixed Values", test_num);
            In1_re = 18'sd10; In1_im = 18'sd20;
            In2_re = 18'sd5;  In2_im = 18'sd-2;
            #1;

            check_outputs(36'sd80, 36'sd90);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative Real and Positive Imaginary", test_num);
            In1_re = 18'sd-10; In1_im = 18'sd5;
            In2_re = 18'sd4;   In2_im = 18'sd-3;
            #1;

            check_outputs(36'sd50, 36'sd-25);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Minimum Value Product", test_num);
            In1_re = 18'sh20000; In1_im = 18'sd0;
            In2_re = 18'sh20000; In2_im = 18'sd0;
            #1;

            check_outputs(36'sd0, 36'sd17179869184);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum/Minimum Mix", test_num);
            In1_re = 18'sd131071; In1_im = 18'sd-131072;
            In2_re = 18'sd2;      In2_im = 18'sd-1;
            #1;

            check_outputs(-36'sd393215, 36'sd131070);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Unit Imaginary Squaring", test_num);
            In1_re = 18'sd0; In1_im = 18'sd1;
            In2_re = 18'sd0; In2_im = 18'sd1;
            #1;

            check_outputs(36'sd0, -36'sd1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complex Cross Product", test_num);
            In1_re = 18'sd0; In1_im = 18'sd1;
            In2_re = 18'sd1; In2_im = 18'sd0;
            #1;

            check_outputs(36'sd1, 36'sd0);
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
        input [35:0] expected_Im;
        input [35:0] expected_Re;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Im === (expected_Im ^ Im ^ expected_Im) &&
                expected_Re === (expected_Re ^ Re ^ expected_Re)) begin
                $display("PASS");
                $display("  Outputs: Im=%h, Re=%h",
                         Im, Re);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Im=%h, Re=%h",
                         expected_Im, expected_Re);
                $display("  Got:      Im=%h, Re=%h",
                         Im, Re);
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
