`timescale 1ns/1ps

module slam_fsm_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg localize_done;
    reg reset;
    reg start;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    slam_fsm dut (
        .clk(clk),
        .localize_done(localize_done),
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
            localize_done = 0;
            repeat(2) @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking Initial Idle State after reset...", test_num);
            reset_dut();

            #1;


            check_outputs(STATE_IDLE);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking Transition Idle -> Mapping via 'start'...", test_num);
            reset_dut();
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            #1;
            #1;

            check_outputs(STATE_MAPPING);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking Transition Mapping -> Localizing (Automatic)...", test_num);
            reset_dut();
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            repeat(20) @(posedge clk);
            #1;
            #1;

            check_outputs(STATE_LOCALIZING);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking Transition Localizing -> Idle via 'localize_done'...", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            repeat(20) @(posedge clk);

            @(posedge clk);
            localize_done = 1;
            @(posedge clk);
            localize_done = 0;
            #1;
            #1;

            check_outputs(STATE_IDLE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checking Idle Persistence without start signal...", test_num);
            reset_dut();
            localize_done = 1;
            repeat(5) @(posedge clk);
            #1;
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
        $display("slam_fsm Testbench");
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
        $dumpvars(0,clk, localize_done, reset, start, state);
    end

endmodule
