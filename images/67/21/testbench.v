`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [143:0] d_flits_m;
    reg mem_done_access;
    reg rst;
    reg v_d_flits_m;
    wire [175:0] d_m_areg_flits;
    wire d_m_areg_state;
    wire v_d_m_areg_flits;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d_flits_m(d_flits_m),
        .mem_done_access(mem_done_access),
        .rst(rst),
        .v_d_flits_m(v_d_flits_m),
        .d_m_areg_flits(d_m_areg_flits),
        .d_m_areg_state(d_m_areg_state),
        .v_d_m_areg_flits(v_d_m_areg_flits)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        v_d_flits_m = 0;
        d_flits_m = 0;
        mem_done_access = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Verifying Idle state after Reset");
        reset_dut();

        #1;


        check_outputs(176'h0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Capturing valid input data");
        reset_dut();
        d_flits_m = DATA_A;
        v_d_flits_m = 1;
        @(posedge clk);
        #1 v_d_flits_m = 0;
        d_flits_m = 144'h0;
        @(posedge clk);
        #1 #1;
 check_outputs(DATA_A_EXT, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Clearing data via mem_done_access signal");
        reset_dut();

        d_flits_m = DATA_A;
        v_d_flits_m = 1;
        @(posedge clk);
        #1 v_d_flits_m = 0;

        @(posedge clk);

        #1 mem_done_access = 1;
        @(posedge clk);
        #1 mem_done_access = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(176'h0, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Ensuring data persists when valid is low");
        reset_dut();
        d_flits_m = DATA_B;
        v_d_flits_m = 1;
        @(posedge clk);
        #1 v_d_flits_m = 0;
        d_flits_m = 144'hFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF_FFFF;
        repeat(5) @(posedge clk);
        #1 #1;
 check_outputs(DATA_B_EXT, 1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Overwriting current data with new flit");
        reset_dut();

        d_flits_m = DATA_A;
        v_d_flits_m = 1;
        @(posedge clk);

        #1 d_flits_m = DATA_B;
        v_d_flits_m = 1;
        @(posedge clk);
        #1 v_d_flits_m = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(DATA_B_EXT, 1'b1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Verifying rst priority over valid input");
        reset_dut();
        d_flits_m = DATA_A;
        v_d_flits_m = 1;
        rst = 1;
        @(posedge clk);
        #1 rst = 0;
        v_d_flits_m = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(176'h0, 1'b0, 1'b0);
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
        input [175:0] expected_d_m_areg_flits;
        input expected_d_m_areg_state;
        input expected_v_d_m_areg_flits;
        begin
            if (expected_d_m_areg_flits === (expected_d_m_areg_flits ^ d_m_areg_flits ^ expected_d_m_areg_flits) &&
                expected_d_m_areg_state === (expected_d_m_areg_state ^ d_m_areg_state ^ expected_d_m_areg_state) &&
                expected_v_d_m_areg_flits === (expected_v_d_m_areg_flits ^ v_d_m_areg_flits ^ expected_v_d_m_areg_flits)) begin
                $display("PASS");
                $display("  Outputs: d_m_areg_flits=%h, d_m_areg_state=%b, v_d_m_areg_flits=%b",
                         d_m_areg_flits, d_m_areg_state, v_d_m_areg_flits);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_m_areg_flits=%h, d_m_areg_state=%b, v_d_m_areg_flits=%b",
                         expected_d_m_areg_flits, expected_d_m_areg_state, expected_v_d_m_areg_flits);
                $display("  Got:      d_m_areg_flits=%h, d_m_areg_state=%b, v_d_m_areg_flits=%b",
                         d_m_areg_flits, d_m_areg_state, v_d_m_areg_flits);
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
        $dumpvars(0,clk, d_flits_m, mem_done_access, rst, v_d_flits_m, d_m_areg_flits, d_m_areg_state, v_d_m_areg_flits);
    end

endmodule
