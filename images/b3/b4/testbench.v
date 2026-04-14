`timescale 1ns/1ps

module washing_machine_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg done;
    reg start;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    washing_machine dut (
        .areset(areset),
        .clk(clk),
        .done(done),
        .start(start),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

    begin
        areset = 1;
        start = 0;
        done = 0;
        @(posedge clk);
        #1;
        areset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Complete Cycle Transition");
        reset_dut();


        start = 1;
        @(posedge clk);
        #1 start = 0;


        @(posedge clk);
        #1 done = 1;
        @(posedge clk);
        #1 done = 0;


        @(posedge clk);
        #1 done = 1;
        @(posedge clk);
        #1 done = 0;


        @(posedge clk);
        #1 done = 1;
        @(posedge clk);
        #1 done = 0;

        #1;


        check_outputs(IDLE);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Start to Washing state");
        reset_dut();

        start = 1;
        @(posedge clk);
        #1 start = 0;


        repeat(2) @(posedge clk);

        #1;


        check_outputs(WASHING);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Move from Washing to Rinsing");
        reset_dut();

        start = 1;
        @(posedge clk);
        #1 start = 0;
        @(posedge clk);
        #1 done = 1;
        @(posedge clk);
        #1 done = 0;

        #1;


        check_outputs(RINSING);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Move from Rinsing to Spinning");
        reset_dut();

        start = 1;
        @(posedge clk);
        #1 start = 0;
        @(posedge clk);
        #1 done = 1;
        @(posedge clk);
        #1 done = 1;
        @(posedge clk);
        #1 done = 0;

        #1;


        check_outputs(SPINNING);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Asynchronous reset during Rinsing");
        reset_dut();

        start = 1;
        @(posedge clk);
        #1 start = 0;
        @(posedge clk);
        #1 done = 1;
        @(posedge clk);
        #1 done = 0;


        #3 areset = 1;
        #10;

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
        $display("washing_machine Testbench");
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
        $dumpvars(0,areset, clk, done, start, state);
    end

endmodule
