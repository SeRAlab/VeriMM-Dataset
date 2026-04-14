`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (

    );
    task reset_system;

        begin
            rst_n = 0;
            sm_psm = 0;
            sm_ps2 = 0;
            repeat(2) @(posedge clk);
            rst_n = 1;
            @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: System Reset and Default State");
            reset_system();

            #1;


            check_outputs(ASCII_IDLE, ASCII_WAIT);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Change sm_psm to State 1 (BUSY)");
            reset_system();
            sm_psm = 3'd1;
            sm_ps2 = 3'd0;
            #1;

            check_outputs(ASCII_BUSY, ASCII_WAIT);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Change sm_ps2 to State 1 (SEND)");
            reset_system();
            sm_psm = 3'd0;
            sm_ps2 = 3'd1;
            #1;

            check_outputs(ASCII_IDLE, ASCII_SEND);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Change Both sm_psm (State 2) and sm_ps2 (State 2)");
            reset_system();
            sm_psm = 3'd2;
            sm_ps2 = 3'd2;

            #1;


            check_outputs(ASCII_DONE, ASCII_RECV);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Rapid switching of states");
            reset_system();
            sm_psm = 3'd1;
            @(posedge clk);
            sm_psm = 3'd0;
            sm_ps2 = 3'd1;
            #1;

            check_outputs(ASCII_IDLE, ASCII_SEND);
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
        begin
            #1; // Small delay for combinational logic to settle
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
