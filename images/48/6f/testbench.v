`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg l0;
    reg l1;
    reg r0;
    reg r1;
    wire le;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .l0(l0),
        .l1(l1),
        .r0(r0),
        .r1(r1),
        .le(le)
    );

        task reset_dut;

        begin
            l0 = 1'b0;
            l1 = 1'b0;
            r0 = 1'b0;
            r1 = 1'b0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %03d: Idle state", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %03d: Capture l0 (Data 0)", test_num);
            reset_dut();
            l0 = 1'b1;
            #20;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %03d: Capture l1 (Data 1)", test_num);
            reset_dut();
            l1 = 1'b1;
            #20;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %03d: Feedback from r0", test_num);
            reset_dut();
            r0 = 1'b1;
            #20;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %03d: Feedback from r1", test_num);
            reset_dut();
            r1 = 1'b1;
            #20;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Running Testcase %03d: Full Handshake Cycle", test_num);
            reset_dut();
            l0 = 1'b1;
            #10;
            r0 = 1'b1;
            #10;
            l0 = 1'b0;
            r0 = 1'b0;
            #20;

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
        input expected_le;
        begin
            if (expected_le === (expected_le ^ le ^ expected_le)) begin
                $display("PASS");
                $display("  Outputs: le=%b",
                         le);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: le=%b",
                         expected_le);
                $display("  Got:      le=%b",
                         le);
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
        $dumpvars(0,l0, l1, r0, r1, le);
    end

endmodule
