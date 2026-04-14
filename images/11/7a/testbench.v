`timescale 1ns/1ps

module watchdog_timer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg refresh;
    reg reset_n;
    reg start;
    reg [3:0] timeout_value;
    wire reset_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    watchdog_timer dut (
        .clk(clk),
        .refresh(refresh),
        .reset_n(reset_n),
        .start(start),
        .timeout_value(timeout_value),
        .reset_out(reset_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            start = 0;
            refresh = 0;
            timeout_value = 0;
            repeat(2) @(posedge clk);
            #1;
            reset_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Timeout Trigger");
            reset_dut();
            timeout_value = 4'd5;
            start = 1;
            repeat (7) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Successful Refresh");
            reset_dut();
            timeout_value = 4'd10;
            start = 1;
            repeat (6) @(posedge clk);
            refresh = 1;
            @(posedge clk);
            refresh = 0;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Timer Not Started");
            reset_dut();
            timeout_value = 4'd5;
            start = 0;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Maximum Timeout Value");
            reset_dut();
            timeout_value = 4'd15;
            start = 1;
            repeat (16) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Continuous Refreshing");
            reset_dut();
            timeout_value = 4'd5;
            start = 1;
            repeat (5) begin
                repeat (2) @(posedge clk);
                refresh = 1;
                @(posedge clk);
                refresh = 0;
            end
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Timeout After One Refresh");
            reset_dut();
            timeout_value = 4'd4;
            start = 1;
            repeat (2) @(posedge clk);
            refresh = 1;
            @(posedge clk);
            refresh = 0;
            repeat (6) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Minimum Timeout Value");
            reset_dut();
            timeout_value = 4'd1;
            start = 1;
            repeat (3) @(posedge clk);
            #1;

            check_outputs(1'b1);
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
        input expected_reset_out;
        begin
            if (expected_reset_out === (expected_reset_out ^ reset_out ^ expected_reset_out)) begin
                $display("PASS");
                $display("  Outputs: reset_out=%b",
                         reset_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reset_out=%b",
                         expected_reset_out);
                $display("  Got:      reset_out=%b",
                         reset_out);
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
        $dumpvars(0,clk, refresh, reset_n, start, timeout_value, reset_out);
    end

endmodule
