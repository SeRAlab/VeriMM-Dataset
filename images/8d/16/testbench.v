`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg down_request;
    reg reset;
    reg up_request;
    wire moving_down;
    wire moving_up;
    wire stationary;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .down_request(down_request),
        .reset(reset),
        .up_request(up_request),
        .moving_down(moving_down),
        .moving_up(moving_up),
        .stationary(stationary)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            up_request = 0;
            down_request = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Reset Behavior - No Requests", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Only Up Request", test_num);
            reset_dut();
            up_request = 1;
            down_request = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Only Down Request", test_num);
            reset_dut();
            up_request = 0;
            down_request = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Priority Check (Both Requests)", test_num);
            reset_dut();
            up_request = 1;
            down_request = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Move Up then Idle", test_num);
            reset_dut();
            up_request = 1;
            @(posedge clk);
            #2;
            up_request = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Move Up then Down Request Priority Override", test_num);
            reset_dut();
            up_request = 1;
            @(posedge clk);
            #2;

            down_request = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: Move Down then Up Request Arrival", test_num);
            reset_dut();
            down_request = 1;
            @(posedge clk);
            #2;

            up_request = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1, 0, 0);
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
        input expected_moving_down;
        input expected_moving_up;
        input expected_stationary;
        begin
            if (expected_moving_down === (expected_moving_down ^ moving_down ^ expected_moving_down) &&
                expected_moving_up === (expected_moving_up ^ moving_up ^ expected_moving_up) &&
                expected_stationary === (expected_stationary ^ stationary ^ expected_stationary)) begin
                $display("PASS");
                $display("  Outputs: moving_down=%b, moving_up=%b, stationary=%b",
                         moving_down, moving_up, stationary);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: moving_down=%b, moving_up=%b, stationary=%b",
                         expected_moving_down, expected_moving_up, expected_stationary);
                $display("  Got:      moving_down=%b, moving_up=%b, stationary=%b",
                         moving_down, moving_up, stationary);
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
        $dumpvars(0,clk, down_request, reset, up_request, moving_down, moving_up, stationary);
    end

endmodule
