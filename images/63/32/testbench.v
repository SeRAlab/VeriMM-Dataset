`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg detector;
    reg nCR;
    wire [15:0] det_counter;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .detector(detector),
        .nCR(nCR),
        .det_counter(det_counter)
    );

    // Clock generation (10ns period)
    initial begin
        detector = 0;
        forever #5 detector = ~detector;
    end

        task reset_dut;

        begin
            nCR = 0;
            #15;
            nCR = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Count to 9 (Single Segment)", test_num);
            reset_dut();
            repeat(9) @(negedge detector);
            #2;
            #1;

            check_outputs(16'h0009);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Roll over 9 to 10 (Nibble Cascade)", test_num);
            reset_dut();
            repeat(10) @(negedge detector);
            #2;
            #1;

            check_outputs(16'h0010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Count to 100 (Double Nibble Cascade)", test_num);
            reset_dut();
            repeat(100) @(negedge detector);
            #2;
            #1;

            check_outputs(16'h0100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Count to 1000 (Triple Nibble Cascade)", test_num);
            reset_dut();
            repeat(1000) @(negedge detector);
            #2;
            #1;

            check_outputs(16'h1000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full Rollover (9999 to 0000)", test_num);
            reset_dut();
            repeat(10000) @(negedge detector);
            #2;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify specific BCD value (1234)", test_num);
            reset_dut();
            repeat(1234) @(negedge detector);
            #2;
            #1;

            check_outputs(16'h1234);
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
        input [15:0] expected_det_counter;
        begin
            if (expected_det_counter === (expected_det_counter ^ det_counter ^ expected_det_counter)) begin
                $display("PASS");
                $display("  Outputs: det_counter=%h",
                         det_counter);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: det_counter=%h",
                         expected_det_counter);
                $display("  Got:      det_counter=%h",
                         det_counter);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,detector, nCR, det_counter);
    end

endmodule
