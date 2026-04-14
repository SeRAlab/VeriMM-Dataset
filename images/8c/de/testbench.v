`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg load;
    reg [11:0] load_val;
    reg reset;
    wire [11:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .load(load),
        .load_val(load_val),
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
            reset = 1;
            enable = 0;
            load = 0;
            load_val = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Synchronous Reset", test_num);
            reset_dut();

            #1;


            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Load Functionality", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            load_val = 12'hA5A;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(12'hA5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Enable/Increment", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            repeat (5) @(posedge clk);
            #1 enable = 0;
            #1;

            check_outputs(12'h005);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Counter stays same when enable=0", test_num);
            reset_dut();
            @(negedge clk);
            enable = 0;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Priority over Load", test_num);
            reset_dut();
            @(negedge clk);
            reset = 1;
            load = 1;
            load_val = 12'hFFF;
            @(posedge clk);
            #1;
            reset = 0;
            load = 0;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load Priority over Enable", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            enable = 1;
            load_val = 12'h123;
            @(posedge clk);
            #1;
            load = 0;
            enable = 0;
            #1;

            check_outputs(12'h123);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Rollover (0xFFF -> 0x000)", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            load_val = 12'hFFF;
            @(posedge clk);
            #1;
            load = 0;
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Complex Sequence (Load then multiple increments)", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            load_val = 12'hABC;
            @(posedge clk);
            #1 load = 0;
            enable = 1;
            repeat (4) @(posedge clk);
            #1 enable = 0;

            #1;


            check_outputs(12'hAC0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Change load_val without Load signal", test_num);
            reset_dut();
            @(negedge clk);
            load = 0;
            enable = 1;
            load_val = 12'h555;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h001);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Synchronous Reset Timing", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            @(posedge clk);
            #1;
            reset = 1;
            #2;

            if (q !== 12'h001) $display("Note: Immediate reset detected (Asynchronous?)");
            @(posedge clk);
            #1 reset = 0;
            #1;

            check_outputs(12'h000);
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
        testcase009();
        testcase010();
        
        
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
        input [11:0] expected_q;
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
        $dumpvars(0,clk, enable, load, load_val, reset, q);
    end

endmodule
