`timescale 1ns/1ps

module binary_counter_2bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg rst_n;
    wire [1:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_counter_2bit dut (
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
            @(negedge clk);
            rst_n = 0;
            enable = 0;
            @(negedge clk);
            rst_n = 1;
            $display("DUT Reset Complete");
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Reset and Idle...");
            reset_dut();
            enable = 0;
            repeat (3) @(negedge clk);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Single Increment...");
            reset_dut();
            enable = 1;
            @(negedge clk);
            enable = 0;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Full Count Range...");
            reset_dut();
            enable = 1;
            repeat (3) @(negedge clk);
            enable = 0;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Wrap-around Behavior...");
            reset_dut();
            enable = 1;
            repeat (4) @(negedge clk);
            enable = 0;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Enable/Disable (Hold Value)...");
            reset_dut();
            enable = 1;
            repeat (2) @(negedge clk);
            enable = 0;
            repeat (2) @(negedge clk);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Reset mid-counting...");
            reset_dut();
            enable = 1;
            repeat (2) @(negedge clk);
            rst_n = 0;
            @(negedge clk);
            rst_n = 1;
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
        $display("binary_counter_2bit Testbench");
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
        input [1:0] expected_count;
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
