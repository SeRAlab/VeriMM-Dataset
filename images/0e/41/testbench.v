`timescale 1ns/1ps

module SATA_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg error_detected;
    reg reset;
    reg start_transfer;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SATA_Controller dut (
        .clk(clk),
        .error_detected(error_detected),
        .reset(reset),
        .start_transfer(start_transfer),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start_transfer = 0;
            error_detected = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Power-on Reset to IDLE", test_num);
            reset_dut();

            #1;


            check_outputs(STATE_IDLE);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Transition IDLE -> TRANSFER", test_num);
            reset_dut();
            @(posedge clk);
            start_transfer = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(STATE_TRANSFER);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Transition TRANSFER -> IDLE (Normal Completion)", test_num);
            reset_dut();
            @(posedge clk);
            start_transfer = 1;
            @(posedge clk);
            start_transfer = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(STATE_IDLE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Transition TRANSFER -> ERROR", test_num);
            reset_dut();
            @(posedge clk);
            start_transfer = 1;
            @(posedge clk);
            error_detected = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(STATE_ERROR);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verify state remains in ERROR until Reset", test_num);
            reset_dut();
            @(posedge clk);
            start_transfer = 1;
            @(posedge clk);
            error_detected = 1;
            @(posedge clk);
            error_detected = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(STATE_ERROR);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Recover from ERROR via Reset", test_num);
            reset_dut();
            @(posedge clk);
            start_transfer = 1;
            @(posedge clk);
            error_detected = 1;
            @(posedge clk);
            reset_dut();
            #1;

            check_outputs(STATE_IDLE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SATA_Controller Testbench");
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
        input [1:0] expected_state;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: state=%h",
                         state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%h",
                         expected_state);
                $display("  Got:      state=%h",
                         state);
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
        $dumpvars(0,clk, error_detected, reset, start_transfer, state);
    end

endmodule
