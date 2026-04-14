`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ctrl;
    reg en;
    reg [3:0] in;
    reg load;
    reg rst;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ctrl(ctrl),
        .en(en),
        .in(in),
        .load(load),
        .rst(rst),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ctrl = 0;
            en = 0;
            load = 0;
            in = 4'b0000;
            #15;
            rst = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying Asynchronous Reset", test_num);
            reset_dut();
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Verifying Synchronous Load", test_num);
            reset_dut();
            @(negedge clk);
            in = 4'hA;
            load = 1;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verifying Count Up (ctrl=1, en=1)", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            ctrl = 1;
            repeat (5) @(negedge clk);
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verifying Count Down (ctrl=0, en=1)", test_num);
            reset_dut();

            @(negedge clk);
            in = 4'h7;
            load = 1;
            @(negedge clk);
            load = 0;
            en = 1;
            ctrl = 0;
            repeat (3) @(negedge clk);
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verifying Enable Signal (en=0)", test_num);
            reset_dut();
            @(negedge clk);
            in = 4'h3;
            load = 1;
            @(negedge clk);
            load = 0;
            en = 0;
            ctrl = 1;
            repeat (4) @(negedge clk);
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Verifying Rollover (4'hF -> 4'h0)", test_num);
            reset_dut();
            @(negedge clk);
            in = 4'hF;
            load = 1;
            @(negedge clk);
            load = 0;
            en = 1;
            ctrl = 1;
            @(negedge clk);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Verifying Underflow (4'h0 -> 4'hF)", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            ctrl = 0;
            @(negedge clk);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Verifying Load Priority", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            ctrl = 1;
            in = 4'hC;
            load = 1;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(4'hC);
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
        input [3:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, ctrl, en, in, load, rst, out);
    end

endmodule
