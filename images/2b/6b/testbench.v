`timescale 1ns/1ps

module SLAM_StateMachine_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg map;
    reg rst_n;
    reg start;
    reg stop;
    wire [1:0] current_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SLAM_StateMachine dut (
        .clk(clk),
        .map(map),
        .rst_n(rst_n),
        .start(start),
        .stop(stop),
        .current_state(current_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            start = 0;
            map = 0;
            stop = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Transition IDLE to NAVIGATING...");
            reset_dut();
            start = 1;
            @(posedge clk);
            #1 start = 0;
            @(posedge clk);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Transition NAVIGATING to MAPPING...");
            reset_dut();

            start = 1;
            @(posedge clk);
            #1 start = 0;

            map = 1;
            @(posedge clk);
            #1 map = 0;
            @(posedge clk);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Full Cycle IDLE -> NAV -> MAP -> IDLE...");
            reset_dut();

            start = 1; @(posedge clk); #1 start = 0;

            map = 1; @(posedge clk); #1 map = 0;

            stop = 1; @(posedge clk); #1 stop = 0;
            @(posedge clk);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Staying in IDLE when no start signal...");
            reset_dut();
            repeat(3) @(posedge clk);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Staying in NAVIGATING when no map signal...");
            reset_dut();
            start = 1;
            @(posedge clk);
            #1 start = 0;
            repeat(3) @(posedge clk);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Staying in MAPPING when no stop signal...");
            reset_dut();
            start = 1; @(posedge clk); #1 start = 0;
            map = 1; @(posedge clk); #1 map = 0;
            repeat(3) @(posedge clk);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: MAP signal while in IDLE (Should stay IDLE)...");
            reset_dut();
            map = 1;
            @(posedge clk);
            #1 map = 0;
            @(posedge clk);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: STOP signal while in NAVIGATING (Should stay NAVIGATING)...");
            reset_dut();
            start = 1;
            @(posedge clk);
            #1 start = 0;
            stop = 1;
            @(posedge clk);
            #1 stop = 0;
            @(posedge clk);
            #1;

            check_outputs(2'b01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SLAM_StateMachine Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [1:0] expected_current_state;
        begin
            if (expected_current_state === (expected_current_state ^ current_state ^ expected_current_state)) begin
                $display("PASS");
                $display("  Outputs: current_state=%h",
                         current_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_state=%h",
                         expected_current_state);
                $display("  Got:      current_state=%h",
                         current_state);
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
        $dumpvars(0,clk, map, rst_n, start, stop, current_state);
    end

endmodule
