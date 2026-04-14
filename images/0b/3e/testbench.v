`timescale 1ns/1ps

module slam_fsm_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg localize_complete;
    reg map_complete;
    reg reset;
    reg start;
    wire [2:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    slam_fsm dut (
        .clk(clk),
        .localize_complete(localize_complete),
        .map_complete(map_complete),
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
            map_complete = 0;
            localize_complete = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset to IDLE...");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: IDLE to MAPPING...");
            test_num = 2;
            reset_dut();

            start = 1;
            @(posedge clk);
            #1 start = 0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(3'd1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: MAPPING to LOCALIZING...");
            test_num = 3;
            reset_dut();


            start = 1;
            @(posedge clk);
            #1 start = 0;


            map_complete = 1;
            @(posedge clk);
            #1 map_complete = 0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(3'd2);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: LOCALIZING to IDLE (Full Cycle)...");
            test_num = 4;
            reset_dut();


            start = 1;
            @(posedge clk);
            #1 start = 0;


            map_complete = 1;
            @(posedge clk);
            #1 map_complete = 0;


            localize_complete = 1;
            @(posedge clk);
            #1 localize_complete = 0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(3'd0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Stay in MAPPING state...");
            test_num = 5;
            reset_dut();

            start = 1;
            @(posedge clk);
            #1 start = 0;


            repeat(3) @(posedge clk);

            #1;

            #1;


            check_outputs(3'd1);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Stay in LOCALIZING state...");
            test_num = 6;
            reset_dut();

            start = 1;
            @(posedge clk);
            #1 start = 0;
            map_complete = 1;
            @(posedge clk);
            #1 map_complete = 0;


            repeat(3) @(posedge clk);

            #1;

            #1;


            check_outputs(3'd2);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning testcase007: Multiple transitions and reset midway...");
            test_num = 7;
            reset_dut();

            start = 1;
            @(posedge clk);
            #1 start = 0;
            map_complete = 1;
            @(posedge clk);
            #1 map_complete = 0;


            reset = 1;
            @(posedge clk);
            #1 reset = 0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(3'd0);
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
        input [2:0] expected_state;
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
        $dumpvars(0,clk, localize_complete, map_complete, reset, start, state);
    end

endmodule
