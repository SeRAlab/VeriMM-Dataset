`timescale 1ns/1ps

module pcie_sm_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg done;
    reg reset;
    reg start;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_sm dut (
        .clk(clk),
        .done(done),
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
            $display("\nResetting DUT...");
            reset = 1;
            start = 0;
            done  = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Checking IDLE state after Reset");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(IDLE);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Transition IDLE -> TRANSMIT");
            test_num = 2;
            reset_dut();

            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            #1;


            check_outputs(TRANSMIT);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Transition TRANSMIT -> RECEIVE");
            test_num = 3;
            reset_dut();


            start = 1;
            @(posedge clk);
            #1;
            start = 0;


            done = 1;
            @(posedge clk);
            #1;
            done = 0;

            #1;


            check_outputs(RECEIVE);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Transition RECEIVE -> IDLE");
            test_num = 4;
            reset_dut();


            start = 1;
            @(posedge clk);
            #1;
            start = 0;


            done = 1;
            @(posedge clk);
            #1;
            done = 0;


            done = 1;
            @(posedge clk);
            #1;
            done = 0;

            #1;


            check_outputs(IDLE);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Async/Sync Reset during TRANSMIT");
            test_num = 5;
            reset_dut();


            start = 1;
            @(posedge clk);
            #1;
            start = 0;


            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;

            #1;


            check_outputs(IDLE);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: IDLE stays IDLE if start is low");
            test_num = 6;
            reset_dut();

            done = 1;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(IDLE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_sm Testbench");
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
        $dumpvars(0,clk, done, reset, start, state);
    end

endmodule
