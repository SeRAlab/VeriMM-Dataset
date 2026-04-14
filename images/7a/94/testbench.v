`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg load;
    reg [7:0] load_val;
    reg reset;
    wire [7:0] q;

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
            load_val = 8'h00;
            #15;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Asynchronous Reset", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Asynchronous Load", test_num);
            reset_dut();
            load_val = 8'hA5;
            #2;
            load = 1;
            #10;
            load = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Basic Increment", test_num);
            reset_dut();
            enable = 1;

            repeat(5) @(posedge clk);
            #2;
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Enable Control", test_num);
            reset_dut();
            enable = 1;
            repeat(3) @(posedge clk);
            @(negedge clk) enable = 0;
            repeat(5) @(posedge clk);
            #2;
            #1;

            check_outputs(8'h03);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Overflow Handling", test_num);
            reset_dut();
            load_val = 8'hFE;
            load = 1;
            #5 load = 0;
            enable = 1;
            repeat(2) @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Reset Priority over Load", test_num);
            reset_dut();
            load_val = 8'hFF;
            load = 1;
            #2;
            reset = 1;
            #10;
            #1;

            check_outputs(8'h00);
            reset = 0;
            load = 0;
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Load Priority over Enable/Clocking", test_num);
            reset_dut();
            enable = 1;
            repeat(2) @(posedge clk);
            load_val = 8'h55;
            @(negedge clk);
            load = 1;
            #2;
            #1;

            check_outputs(8'h55);
            load = 0;
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Async Load Timing", test_num);
            reset_dut();
            @(posedge clk);
            #2;
            load_val = 8'h77;
            load = 1;
            #1;
            #1;

            check_outputs(8'h77);
            load = 0;
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
        input [7:0] expected_q;
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
