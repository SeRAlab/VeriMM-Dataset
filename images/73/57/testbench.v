`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [8:0] ctrl;
    reg rst;
    wire [3:0] td_mode;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ctrl(ctrl),
        .rst(rst),
        .td_mode(td_mode)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ctrl = 9'b0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checking asynchronous reset default value", test_num);
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mode 0 (ctrl[8:6] = 3'b000)", test_num);
            reset_dut();
            ctrl = 9'b000_101010;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mode 1 (ctrl[8:6] = 3'b001)", test_num);
            reset_dut();
            ctrl = 9'b001_000000;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mode 2 (ctrl[8:6] = 3'b010)", test_num);
            reset_dut();
            ctrl = 9'b010_111111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mode 3 (ctrl[8:6] = 3'b011)", test_num);
            reset_dut();
            ctrl = 9'b011_010101;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mode 4 (ctrl[8:6] = 3'b100)", test_num);
            reset_dut();
            ctrl = 9'b100_000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mode 5 (ctrl[8:6] = 3'b101)", test_num);
            reset_dut();
            ctrl = 9'b101_110011;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mode 6 (ctrl[8:6] = 3'b110)", test_num);
            reset_dut();
            ctrl = 9'b110_001100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mode 7 (ctrl[8:6] = 3'b111)", test_num);
            reset_dut();
            ctrl = 9'b111_111111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mode 3 with different lower bits", test_num);
            reset_dut();
            ctrl = 9'b011_111111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0011);
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
        input [3:0] expected_td_mode;
        begin
            if (expected_td_mode === (expected_td_mode ^ td_mode ^ expected_td_mode)) begin
                $display("PASS");
                $display("  Outputs: td_mode=%h",
                         td_mode);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: td_mode=%h",
                         expected_td_mode);
                $display("  Got:      td_mode=%h",
                         td_mode);
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
        $dumpvars(0,clk, ctrl, rst, td_mode);
    end

endmodule
