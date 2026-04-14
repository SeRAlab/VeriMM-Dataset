`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    wire [3:0] producer_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .producer_data(producer_data)
    );

        task reset_dut;

        begin


            $display("\n[Time %0t] Initializing testcase %0d...", $time, test_num + 1);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();

            #1;
            $display("Test: Check initial state (expect 0)");
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();


            #5;
            $display("Test: Check first increment (expect 1)");
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();




            #70;
            $display("Test: Check mid-range value 8");
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();



            #80;
            $display("Test: Check rollover (15 -> 0)");
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();


            #10;
            $display("Test: Check increment post-rollover (expect 1)");
            #1;

            check_outputs(4'd1);
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
        input [3:0] expected_producer_data;
        begin
            if (expected_producer_data === (expected_producer_data ^ producer_data ^ expected_producer_data)) begin
                $display("PASS");
                $display("  Outputs: producer_data=%h",
                         producer_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: producer_data=%h",
                         expected_producer_data);
                $display("  Got:      producer_data=%h",
                         producer_data);
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
        $dumpvars(0,producer_data);
    end

endmodule
