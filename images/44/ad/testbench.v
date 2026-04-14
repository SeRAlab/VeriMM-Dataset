`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [29:0] shiftMe;
    wire [31:0] shifted;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .shiftMe(shiftMe),
        .shifted(shifted)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros", test_num);
            shiftMe = 30'h0000_0000;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Ones", test_num);
            shiftMe = 30'h3FFF_FFFF;

            #1;


            check_outputs(32'hFFFF_FFFC);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: LSB Bit Set", test_num);
            shiftMe = 30'h0000_0001;

            #1;


            check_outputs(32'h0000_0004);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: MSB Bit Set", test_num);
            shiftMe = 30'h2000_0000;

            #1;


            check_outputs(32'h8000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating Bits (1010...)", test_num);
            shiftMe = 30'h2AAA_AAAA;

            #1;


            check_outputs(32'hAAAA_AAA8);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Walking Bit Pattern", test_num);
            shiftMe = 30'h1555_5555;

            #1;


            check_outputs(32'h5555_5554);
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
        input [31:0] expected_shifted;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_shifted === (expected_shifted ^ shifted ^ expected_shifted)) begin
                $display("PASS");
                $display("  Outputs: shifted=%h",
                         shifted);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shifted=%h",
                         expected_shifted);
                $display("  Got:      shifted=%h",
                         shifted);
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
