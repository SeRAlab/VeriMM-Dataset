`timescale 1ns/1ps

module up_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg rst_n;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_counter dut (
        .clk(clk),
        .enable(enable),
        .rst_n(rst_n),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            rst_n = 0;
            #15;
            rst_n = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Reset Check");
            test_num = 1;
            reset_dut();
            @(negedge clk);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Single Increment");
            test_num = 2;
            reset_dut();
            @(negedge clk);
            enable = 1;
            @(negedge clk);
            enable = 0;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Multiple Increments (5 steps)");
            test_num = 3;
            reset_dut();
            @(negedge clk);
            enable = 1;
            repeat(5) @(negedge clk);
            enable = 0;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Enable Signal Gating");
            test_num = 4;
            reset_dut();
            @(negedge clk);
            enable = 1;
            repeat(3) @(negedge clk);
            enable = 0;
            repeat(4) @(negedge clk);
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Rollover (15 to 0)");
            test_num = 5;
            reset_dut();
            @(negedge clk);
            enable = 1;
            repeat(16) @(negedge clk);
            enable = 0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Asynchronous Reset Timing");
            test_num = 6;
            reset_dut();
            @(negedge clk);
            enable = 1;
            repeat(4) @(negedge clk);
            #2;
            rst_n = 0;
            #1;
            #1;

            check_outputs(4'h0);
            rst_n = 1;
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning Testcase 007: Reach Maximum Count (15)");
            test_num = 7;
            reset_dut();
            @(negedge clk);
            enable = 1;
            repeat(15) @(negedge clk);
            enable = 0;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase008;

        begin
            $display("\nRunning Testcase 008: Intermittent Enable Signals");
            test_num = 8;
            reset_dut();
            @(negedge clk);
            enable = 1; @(negedge clk);
            enable = 0; @(negedge clk);
            enable = 1; @(negedge clk);
            enable = 0; @(negedge clk);
            enable = 1; @(negedge clk);
            enable = 0;
            #1;

            check_outputs(4'h3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_counter Testbench");
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
        input [3:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, enable, rst_n, count);
    end

endmodule
