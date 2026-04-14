`timescale 1ns/1ps

module UpDownCounter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg down;
    reg reset;
    reg up;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    UpDownCounter dut (
        .clk(clk),
        .down(down),
        .reset(reset),
        .up(up),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            up = 0;
            down = 0;
            @(posedge clk);
            reset = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Reset Check");
            reset_dut();
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Basic Up Counting (0 to 5)");
            reset_dut();
            up = 1;
            repeat(5) @(posedge clk);
            up = 0;
            #1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Basic Down Counting (Start at 10, dec to 7)");
            reset_dut();

            up = 1;
            repeat(10) @(posedge clk);
            up = 0;

            down = 1;
            repeat(3) @(posedge clk);
            down = 0;
            #1;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Overflow Check (15 -> 0)");
            reset_dut();
            up = 1;
            repeat(16) @(posedge clk);
            up = 0;
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Underflow Check (0 -> 15)");
            reset_dut();
            down = 1;
            @(posedge clk);
            down = 0;
            #1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Hold State Check");
            reset_dut();
            up = 1;
            repeat(3) @(posedge clk);
            up = 0;
            down = 0;
            repeat(5) @(posedge clk);
            #1;
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
        $display("UpDownCounter Testbench");
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
        $dumpvars(0,clk, down, reset, up, count);
    end

endmodule
