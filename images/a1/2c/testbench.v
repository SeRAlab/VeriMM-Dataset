`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg decrement;
    reg enable;
    reg reset;
    wire [1:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .decrement(decrement),
        .enable(enable),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            decrement = 0;
            reset = 0;
            #2 reset = 1;
            #5 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Verify reset to zero");
            reset_dut();
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Single Increment (Enable)");
            reset_dut();
            @(posedge clk);
            enable = 1;
            decrement = 0;
            @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Increment 4 times (Wrap-around 2-bit)");
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat(4) @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Decrement from zero (Wrap to 3)");
            reset_dut();
            @(posedge clk);
            decrement = 1;
            enable = 0;
            @(posedge clk);
            decrement = 0;
            #1;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Increment twice, then decrement once");
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat(2) @(posedge clk);
            enable = 0;
            decrement = 1;
            @(posedge clk);
            decrement = 0;
            #1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Idle state check");
            reset_dut();
            @(posedge clk);
            enable = 1;
            @(posedge clk);
            enable = 0;
            decrement = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Enable and Decrement simultaneously");
            reset_dut();
            @(posedge clk);
            enable = 1;
            @(posedge clk);
            enable = 1;
            decrement = 1;
            @(posedge clk);
            enable = 0;
            decrement = 0;
            #1;


            #1;



            check_outputs(q);
            $display("  Resulting q during simultaneous signals: %h", q);
            pass_count = pass_count + 1;
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
        input [1:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, decrement, enable, reset, q);
    end

endmodule
