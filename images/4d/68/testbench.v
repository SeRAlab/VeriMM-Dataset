`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg count_enable;
    reg [15:0] data;
    reg enable;
    reg reset;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .count_enable(count_enable),
        .data(data),
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
            count_enable = 0;
            data = 0;
            #2;
            reset = 1;
            #10;
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Reset", test_num);
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Synchronous Load Data", test_num);
            reset_dut();
            @(negedge clk);
            data = 16'hABCD;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Synchronous Increment", test_num);
            reset_dut();
            @(negedge clk);
            data = 16'h0005;
            enable = 1;
            @(posedge clk);
            @(negedge clk);
            enable = 0;
            count_enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0006);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Priority Check (Load vs Count)", test_num);
            reset_dut();
            @(negedge clk);
            data = 16'h1111;
            enable = 1;
            count_enable = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h1111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Hold Value (No enables)", test_num);
            reset_dut();
            @(negedge clk);
            data = 16'h55AA;
            enable = 1;
            @(posedge clk);
            @(negedge clk);
            enable = 0;
            count_enable = 0;
            data = 16'hFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h55AA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Counter Roll-over", test_num);
            reset_dut();
            @(negedge clk);
            data = 16'hFFFF;
            enable = 1;
            @(posedge clk);
            @(negedge clk);
            enable = 0;
            count_enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Multiple Increments", test_num);
            reset_dut();
            @(negedge clk);
            count_enable = 1;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd10);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Asynchronous Reset Mid-cycle", test_num);
            reset_dut();
            @(negedge clk);
            data = 16'h7777;
            enable = 1;
            @(posedge clk);
            #2;
            reset = 1;
            #1;
            #1;

            check_outputs(16'h0000);
            reset = 0;
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
        input [15:0] expected_q;
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
        $dumpvars(0,clk, count_enable, data, enable, reset, q);
    end

endmodule
