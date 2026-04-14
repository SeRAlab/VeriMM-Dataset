`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg async_reset;
    reg clk;
    reg [1:0] enable;
    wire [1:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .async_reset(async_reset),
        .clk(clk),
        .enable(enable),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            async_reset = 1;
            enable = 2'b00;
            #12;
            async_reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Initial Reset", test_num);
            reset_dut();
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Single Increment", test_num);
            reset_dut();
            enable = 2'b01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Increment Wrap Around", test_num);
            reset_dut();
            enable = 2'b01;
            repeat(4) @(posedge clk);
            #2;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Single Decrement (Underflow)", test_num);
            reset_dut();
            enable = 2'b10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Hold State", test_num);
            reset_dut();
            enable = 2'b01;
            @(posedge clk);
            enable = 2'b00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Multiple Decrements", test_num);
            reset_dut();
            enable = 2'b10;
            repeat(2) @(posedge clk);
            #2;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Mixed Up/Down Operations", test_num);
            reset_dut();
            enable = 2'b01;
            @(posedge clk);
            enable = 2'b01;
            @(posedge clk);
            enable = 2'b10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Mid-cycle Async Reset", test_num);
            reset_dut();
            enable = 2'b01;
            @(posedge clk);
            enable = 2'b01;
            #2;
            async_reset = 1;
            #1;
            #1;

            check_outputs(2'b00);
            async_reset = 0;
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
        $dumpvars(0,async_reset, clk, enable, count);
    end

endmodule
