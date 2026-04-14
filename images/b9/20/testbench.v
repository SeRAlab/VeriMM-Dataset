`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] dt1;
    reg [1:0] dt2;
    reg [6:0] kc;
    reg [5:0] kf;
    reg [3:0] mul;
    reg [7:0] pm;
    reg [2:0] pms;
    reg rst;
    wire [15:0] pg_phase;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dt1(dt1),
        .dt2(dt2),
        .kc(kc),
        .kf(kf),
        .mul(mul),
        .pm(pm),
        .pms(pms),
        .rst(rst),
        .pg_phase(pg_phase)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        kc = 0; kf = 0; mul = 0; dt1 = 0; dt2 = 0; pm = 0; pms = 0;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        @(posedge clk);
        #1 #1;
 check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        kc = 20; kf = 10; mul = 2; dt1 = 0; dt2 = 0; pm = 0; pms = 0;
        expected_val = (20 + 10) * 2;
        @(posedge clk);
        #1 #1;
 check_outputs(expected_val);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        kc = 15; kf = 5; mul = 4; dt1 = 7; dt2 = 3; pm = 0; pms = 0;
        expected_val = (15 + 5 + 7 + 3) * 4;
        @(posedge clk);
        #1 #1;
 check_outputs(expected_val);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        kc = 10; kf = 0; mul = 1; dt1 = 0; dt2 = 0;
        pm = 8'd25; pms = 2;
        expected_val = (10 * 1) + (25 << 2);
        @(posedge clk);
        #1 #1;
 check_outputs(expected_val);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        kc = 50; kf = 0; mul = 2; dt1 = 0; dt2 = 0;
        pm = -8'd10; pms = 3;
        expected_val = (50 * 2) + ($signed(pm) <<< 3);
        @(posedge clk);
        #1 #1;
 check_outputs(expected_val);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        kc = 0; kf = 0; mul = 0; dt1 = 0; dt2 = 0;
        pm = 8'd1; pms = 7;
        expected_val = (1 << 7);
        @(posedge clk);
        #1 #1;
 check_outputs(expected_val);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        kc = 127; kf = 63; mul = 15; dt1 = 7; dt2 = 3;
        pm = 127; pms = 7;

        expected_val = ((127 + 63 + 7 + 3) * 15) + ($signed(pm) <<< 7);
        @(posedge clk);
        #1 #1;
 check_outputs(expected_val);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();
        kc = 100; kf = 50; mul = 0; dt1 = 5; dt2 = 2; pm = 10; pms = 1;
        expected_val = 0 + (10 << 1);
        @(posedge clk);
        #1 #1;
 check_outputs(expected_val);
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
        input [15:0] expected_pg_phase;
        begin
            if (expected_pg_phase === (expected_pg_phase ^ pg_phase ^ expected_pg_phase)) begin
                $display("PASS");
                $display("  Outputs: pg_phase=%h",
                         pg_phase);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pg_phase=%h",
                         expected_pg_phase);
                $display("  Got:      pg_phase=%h",
                         pg_phase);
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
        $dumpvars(0,clk, dt1, dt2, kc, kf, mul, pm, pms, rst, pg_phase);
    end

endmodule
