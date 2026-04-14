`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] rd_stage;
    reg rst;
    wire mode_SSHRin;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rd_stage(rd_stage),
        .rst(rst),
        .mode_SSHRin(mode_SSHRin)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        rd_stage = 4'b0000;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Test %0d: Initial Reset State", test_num);

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Test %0d: Condition A (rd_stage=4'b0101)", test_num);
        rd_stage = 4'b0101;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Test %0d: Condition B (rd_stage=4'b1010)", test_num);
        rd_stage = 4'b1010;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Test %0d: Both Conditions (rd_stage=4'b1111)", test_num);
        rd_stage = 4'b1111;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Test %0d: Zero inputs (rd_stage=4'b0000)", test_num);
        rd_stage = 4'b0000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Test %0d: Partial Condition A (rd_stage=4'b0001)", test_num);
        rd_stage = 4'b0001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        $display("Test %0d: Misaligned bits (rd_stage=4'b1001)", test_num);
        rd_stage = 4'b1001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = 8;
        $display("Test %0d: Inner bits only (rd_stage=4'b0110)", test_num);
        rd_stage = 4'b0110;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
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
        input expected_mode_SSHRin;
        begin
            if (expected_mode_SSHRin === (expected_mode_SSHRin ^ mode_SSHRin ^ expected_mode_SSHRin)) begin
                $display("PASS");
                $display("  Outputs: mode_SSHRin=%b",
                         mode_SSHRin);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mode_SSHRin=%b",
                         expected_mode_SSHRin);
                $display("  Got:      mode_SSHRin=%b",
                         mode_SSHRin);
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
        $dumpvars(0,clk, rd_stage, rst, mode_SSHRin);
    end

endmodule
