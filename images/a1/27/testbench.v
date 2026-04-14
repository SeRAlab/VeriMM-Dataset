`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ce;
    reg clk;
    reg [3:0] compare_val;
    reg ctrl;
    reg load;
    reg [3:0] preset;
    reg rst_n;
    wire comp;
    wire [3:0] count;
    wire tc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce(ce),
        .clk(clk),
        .compare_val(compare_val),
        .ctrl(ctrl),
        .load(load),
        .preset(preset),
        .rst_n(rst_n),
        .comp(comp),
        .count(count),
        .tc(tc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            ce = 0;
            load = 0;
            ctrl = 0;
            preset = 0;
            compare_val = 0;
            #10;
            rst_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Reset", test_num);
            reset_dut();



            ctrl = 1;
            compare_val = 4'h0;
            #5;
            #1;

            check_outputs(1'b1, 4'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Load Value", test_num);
            reset_dut();
            preset = 4'hA;
            load = 1;
            @(posedge clk);
            #2;
            load = 0;
            #1;

            check_outputs(1'b0, 4'hA, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Count Up", test_num);
            reset_dut();
            ce = 1;
            ctrl = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 4'h1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Count Down", test_num);
            reset_dut();

            preset = 4'h5;
            load = 1;
            @(posedge clk);
            #2;
            load = 0;
            ce = 1;
            ctrl = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 4'h4, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: TC Up", test_num);
            reset_dut();
            preset = 4'hF;
            load = 1;
            ctrl = 1;
            @(posedge clk);
            #2;
            load = 0;
            #1;

            check_outputs(1'b0, 4'hF, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: TC Down", test_num);
            reset_dut();
            preset = 4'h0;
            load = 1;
            ctrl = 0;
            @(posedge clk);
            #2;
            load = 0;
            #1;

            check_outputs(1'b0, 4'h0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Comparison", test_num);
            reset_dut();
            preset = 4'h7;
            compare_val = 4'h7;
            load = 1;
            @(posedge clk);
            #2;
            load = 0;
            #1;

            check_outputs(1'b1, 4'h7, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Count Enable Disable", test_num);
            reset_dut();
            preset = 4'h3;
            load = 1;
            @(posedge clk);
            #2;
            load = 0;
            ce = 0;
            ctrl = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 4'h3, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %03d: Wrap Around Up", test_num);
            reset_dut();
            preset = 4'hF;
            load = 1;
            @(posedge clk);
            #2;
            load = 0;
            ce = 1;
            ctrl = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 4'h0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %03d: Wrap Around Down", test_num);
            reset_dut();
            preset = 4'h0;
            load = 1;
            @(posedge clk);
            #2;
            load = 0;
            ce = 1;
            ctrl = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 4'hF, 1'b0);
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
        input expected_comp;
        input [3:0] expected_count;
        input expected_tc;
        begin
            if (expected_comp === (expected_comp ^ comp ^ expected_comp) &&
                expected_count === (expected_count ^ count ^ expected_count) &&
                expected_tc === (expected_tc ^ tc ^ expected_tc)) begin
                $display("PASS");
                $display("  Outputs: comp=%b, count=%h, tc=%b",
                         comp, count, tc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: comp=%b, count=%h, tc=%b",
                         expected_comp, expected_count, expected_tc);
                $display("  Got:      comp=%b, count=%h, tc=%b",
                         comp, count, tc);
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
        $dumpvars(0,ce, clk, compare_val, ctrl, load, preset, rst_n, comp, count, tc);
    end

endmodule
