`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg PWRDN;
    wire CLKOUT_FABRIC;
    wire CLKOUT_HARDIP;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PWRDN(PWRDN),
        .CLKOUT_FABRIC(CLKOUT_FABRIC),
        .CLKOUT_HARDIP(CLKOUT_HARDIP)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Power-down mode - Asserting PWRDN", test_num);

            PWRDN = 1;
            #50;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Oscillator Start - Deasserting PWRDN (Initial Phase)", test_num);

            PWRDN = 1;
            #20;
            PWRDN = 0;


            #5;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Oscillator Toggle - Checking second phase", test_num);

            PWRDN = 1;
            #20;
            PWRDN = 0;

            #25;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Oscillator Toggle - Checking third phase", test_num);

            PWRDN = 1;
            #20;
            PWRDN = 0;

            #45;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Re-asserting PWRDN during oscillation", test_num);

            PWRDN = 1;
            #10;
            PWRDN = 0;
            #10;

            PWRDN = 1;
            #5;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Long duration stability check", test_num);

            PWRDN = 1;
            #10;
            PWRDN = 0;

            #185.18;
            #10;




            #1;





            check_outputs(1'b1, 1'b1);
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
        input expected_CLKOUT_FABRIC;
        input expected_CLKOUT_HARDIP;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CLKOUT_FABRIC === (expected_CLKOUT_FABRIC ^ CLKOUT_FABRIC ^ expected_CLKOUT_FABRIC) &&
                expected_CLKOUT_HARDIP === (expected_CLKOUT_HARDIP ^ CLKOUT_HARDIP ^ expected_CLKOUT_HARDIP)) begin
                $display("PASS");
                $display("  Outputs: CLKOUT_FABRIC=%b, CLKOUT_HARDIP=%b",
                         CLKOUT_FABRIC, CLKOUT_HARDIP);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CLKOUT_FABRIC=%b, CLKOUT_HARDIP=%b",
                         expected_CLKOUT_FABRIC, expected_CLKOUT_HARDIP);
                $display("  Got:      CLKOUT_FABRIC=%b, CLKOUT_HARDIP=%b",
                         CLKOUT_FABRIC, CLKOUT_HARDIP);
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
