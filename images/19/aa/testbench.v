`timescale 1ns/1ps

module sata_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg error;
    reg operation_complete;
    reg reset;
    reg start;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sata_controller dut (
        .clk(clk),
        .error(error),
        .operation_complete(operation_complete),
        .reset(reset),
        .start(start),
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
            start = 0;
            error = 0;
            operation_complete = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Test Case 001: Normal Operation Flow");
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            @(posedge clk);
            operation_complete = 1;
            @(posedge clk);
            operation_complete = 0;
            #1 #1;
 check_outputs(STATE_IDLE);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Test Case 002: Error during Active State");
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            @(posedge clk);
            error = 1;
            @(posedge clk);
            error = 0;
            #1 #1;
 check_outputs(STATE_ERROR);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Test Case 003: Error from Idle State");
            reset_dut();

            @(posedge clk);
            error = 1;
            @(posedge clk);
            error = 0;
            #1 #1;
 check_outputs(STATE_ERROR);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Test Case 004: Reset recovery from Error");
            reset_dut();

            error = 1;
            @(posedge clk);
            error = 0;

            reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(STATE_IDLE);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Test Case 005: Ignoring Start in Error State");
            reset_dut();

            error = 1;
            @(posedge clk);
            error = 0;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            #1 #1;
 check_outputs(STATE_ERROR);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sata_controller Testbench");
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
        $dumpvars(0,clk, error, operation_complete, reset, start, state);
    end

endmodule
