`timescale 1ns/1ps

module watchdog_timer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset_signal;
    reg rst;
    wire timeout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    watchdog_timer dut (
        .clk(clk),
        .enable(enable),
        .reset_signal(reset_signal),
        .rst(rst),
        .timeout(timeout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 0;
            reset_signal = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Timeout Trigger", test_num);
            reset_dut();
            enable = 1;


            repeat (20) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Prevent Timeout with reset_signal", test_num);
            reset_dut();
            enable = 1;
            repeat (5) @(posedge clk);
            reset_signal = 1;
            @(posedge clk);
            reset_signal = 0;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Timer Paused when enable=0", test_num);
            reset_dut();
            enable = 1;
            repeat (5) @(posedge clk);
            enable = 0;
            repeat (15) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: System Reset clears timeout flag", test_num);
            reset_dut();
            enable = 1;
            repeat (20) @(posedge clk);
            rst = 1;
            @(posedge clk);
            rst = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Kicks and eventual timeout", test_num);
            reset_dut();
            enable = 1;
            repeat (5) @(posedge clk);
            reset_signal = 1; @(posedge clk); reset_signal = 0;
            repeat (5) @(posedge clk);
            reset_signal = 1; @(posedge clk); reset_signal = 0;
            repeat (20) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: reset_signal clears timeout flag", test_num);
            reset_dut();
            enable = 1;
            repeat (20) @(posedge clk);
            reset_signal = 1;
            @(posedge clk);
            reset_signal = 0;
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
        input expected_timeout;
        begin
            if (expected_timeout === (expected_timeout ^ timeout ^ expected_timeout)) begin
                $display("PASS");
                $display("  Outputs: timeout=%b",
                         timeout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: timeout=%b",
                         expected_timeout);
                $display("  Got:      timeout=%b",
                         timeout);
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
        $dumpvars(0,clk, enable, reset_signal, rst, timeout);
    end

endmodule
