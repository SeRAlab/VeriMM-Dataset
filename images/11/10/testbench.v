`timescale 1ns/1ps

module wifi_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg start;
    reg success;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wifi_module dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .success(success),
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
            success = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Normal Connection Sequence", test_num);
            reset_dut();


            @(negedge clk);
            start = 1;
            @(negedge clk);
            start = 0;


            @(negedge clk);
            success = 1;
            @(negedge clk);
            success = 0;

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Stay in IDLE", test_num);
            reset_dut();

            @(negedge clk);
            start = 0;
            success = 1;
            repeat(2) @(negedge clk);

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Remain in CONNECTING state", test_num);
            reset_dut();


            @(negedge clk);
            start = 1;
            @(negedge clk);
            start = 0;


            success = 0;
            repeat(3) @(negedge clk);

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Reset from CONNECTED state", test_num);
            reset_dut();


            @(negedge clk) start = 1;
            @(negedge clk) start = 0; success = 1;
            @(negedge clk) success = 0;


            @(negedge clk) rst = 1;
            @(negedge clk) rst = 0;

            #1;


            check_outputs(2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wifi_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        $dumpvars(0,clk, rst, start, success, state);
    end

endmodule
