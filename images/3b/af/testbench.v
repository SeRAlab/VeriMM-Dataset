`timescale 1ns/1ps

module watchdog_timer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [3:0] timeout;
    wire timeout_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    watchdog_timer dut (
        .clk(clk),
        .rst(rst),
        .timeout(timeout),
        .timeout_signal(timeout_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            timeout = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Timeout", test_num);
            reset_dut();
            timeout = 4'd5;

            repeat (7) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Watchdog Kick Prevents Timeout", test_num);
            reset_dut();
            timeout = 4'd8;
            repeat (4) @(posedge clk);
            #1 rst = 1;
            @(posedge clk);
            #1 rst = 0;
            repeat (4) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Recovery from Timeout", test_num);
            reset_dut();
            timeout = 4'd3;
            repeat (5) @(posedge clk);
            #1 rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Dynamic Timeout Configuration", test_num);
            reset_dut();
            timeout = 4'd10;
            repeat (8) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Minimum Timeout", test_num);
            reset_dut();
            timeout = 4'd1;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Continuous Reset", test_num);
            reset_dut();
            timeout = 4'd2;
            rst = 1;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("watchdog_timer Testbench");
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
        input expected_timeout_signal;
        begin
            if (expected_timeout_signal === (expected_timeout_signal ^ timeout_signal ^ expected_timeout_signal)) begin
                $display("PASS");
                $display("  Outputs: timeout_signal=%b",
                         timeout_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: timeout_signal=%b",
                         expected_timeout_signal);
                $display("  Got:      timeout_signal=%b",
                         timeout_signal);
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
        $dumpvars(0,clk, rst, timeout, timeout_signal);
    end

endmodule
