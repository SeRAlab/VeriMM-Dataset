`timescale 1ns/1ps

module robot_slam_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg map;
    reg rst;
    reg start;
    reg stop;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    robot_slam dut (
        .clk(clk),
        .map(map),
        .rst(rst),
        .start(start),
        .stop(stop),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            map = 0;
            stop = 0;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset to IDLE", test_num);
            reset_dut();
            #1;

            check_outputs(IDLE);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: IDLE -> MOVING", test_num);
            reset_dut();
            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;
            #1;

            check_outputs(MOVING);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: IDLE -> MAPPING", test_num);
            reset_dut();
            @(posedge clk);
            #1 map = 1;
            @(posedge clk);
            #1 map = 0;
            #1;

            check_outputs(MAPPING);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: MOVING -> MAPPING", test_num);
            reset_dut();

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            @(posedge clk);
            #1 map = 1;
            @(posedge clk);
            #1 map = 0;
            #1;

            check_outputs(MAPPING);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: MOVING -> IDLE", test_num);
            reset_dut();

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            @(posedge clk);
            #1 stop = 1;
            @(posedge clk);
            #1 stop = 0;
            #1;

            check_outputs(IDLE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: MAPPING -> MOVING", test_num);
            reset_dut();

            @(posedge clk);
            #1 map = 1;
            @(posedge clk);
            #1 map = 0;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;
            #1;

            check_outputs(MOVING);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: MAPPING -> IDLE", test_num);
            reset_dut();

            @(posedge clk);
            #1 map = 1;
            @(posedge clk);
            #1 map = 0;

            @(posedge clk);
            #1 stop = 1;
            @(posedge clk);
            #1 stop = 0;
            #1;

            check_outputs(IDLE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: IDLE stays IDLE on 'stop'", test_num);
            reset_dut();
            @(posedge clk);
            #1 stop = 1;
            @(posedge clk);
            #1 stop = 0;
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
        $display("robot_slam Testbench");
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
        $dumpvars(0,clk, map, rst, start, stop, state);
    end

endmodule
