`timescale 1ns/1ps

module UpDownCounter4_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    reg up_down;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    UpDownCounter4 dut (
        .clk(clk),
        .en(en),
        .rst(rst),
        .up_down(up_down),
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
            rst = 1;
            en = 0;
            up_down = 0;
            @(negedge clk);
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Reset logic");
            reset_dut();

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Basic Up Counting (Increment 5 times)");
            reset_dut();
            @(negedge clk);
            en = 1;
            up_down = 1;
            repeat(5) @(negedge clk);
            en = 0;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Basic Down Counting (From 0 to 13)");
            reset_dut();
            @(negedge clk);
            en = 1;
            up_down = 0;
            repeat(3) @(negedge clk);
            en = 0;
            #1;

            check_outputs(4'hD);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Enable/Disable behavior");
            reset_dut();
            @(negedge clk);
            en = 1;
            up_down = 1;
            repeat(2) @(negedge clk);
            en = 0;
            repeat(3) @(negedge clk);
            en = 1;
            repeat(1) @(negedge clk);
            en = 0;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Up Rollover (15 back to 0)");
            reset_dut();
            @(negedge clk);
            en = 1;
            up_down = 1;
            repeat(16) @(negedge clk);
            en = 0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Down Underflow (0 to 15)");
            reset_dut();
            @(negedge clk);
            en = 1;
            up_down = 0;
            repeat(1) @(negedge clk);
            en = 0;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Switching Up to Down");
            reset_dut();
            @(negedge clk);
            en = 1;
            up_down = 1;
            repeat(10) @(negedge clk);
            up_down = 0;
            repeat(4) @(negedge clk);
            en = 0;
            #1;

            check_outputs(4'h6);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("UpDownCounter4 Testbench");
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
        $dumpvars(0,clk, en, rst, up_down, count);
    end

endmodule
