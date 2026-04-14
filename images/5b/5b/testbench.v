`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] f0;
    reg rstn;
    wire [15:0] m_axis_phase_tdata;
    wire m_axis_phase_tvalid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .f0(f0),
        .rstn(rstn),
        .m_axis_phase_tdata(m_axis_phase_tdata),
        .m_axis_phase_tvalid(m_axis_phase_tvalid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rstn = 0;
            f0 = 0;
            repeat(5) @(posedge clk);
            #1 rstn = 1;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Zero Input (f0 = 0)", test_num);
            reset_dut();
            f0 = 32'h0000_0000;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Power of 2 Input (f0 = 128)", test_num);
            reset_dut();
            f0 = 32'd128;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h006B, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Large Input (f0 = 1,000,000)", test_num);
            reset_dut();
            f0 = 32'd1000000;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'hC161, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Max Input (f0 = 0xFFFFFFFF)", test_num);
            reset_dut();
            f0 = 32'hFFFF_FFFF;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Arbitrary Value (f0 = 12345678)", test_num);
            reset_dut();
            f0 = 32'd12345678;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h7957, 1'b1);
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
        input [15:0] expected_m_axis_phase_tdata;
        input expected_m_axis_phase_tvalid;
        begin
            if (expected_m_axis_phase_tdata === (expected_m_axis_phase_tdata ^ m_axis_phase_tdata ^ expected_m_axis_phase_tdata) &&
                expected_m_axis_phase_tvalid === (expected_m_axis_phase_tvalid ^ m_axis_phase_tvalid ^ expected_m_axis_phase_tvalid)) begin
                $display("PASS");
                $display("  Outputs: m_axis_phase_tdata=%h, m_axis_phase_tvalid=%b",
                         m_axis_phase_tdata, m_axis_phase_tvalid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m_axis_phase_tdata=%h, m_axis_phase_tvalid=%b",
                         expected_m_axis_phase_tdata, expected_m_axis_phase_tvalid);
                $display("  Got:      m_axis_phase_tdata=%h, m_axis_phase_tvalid=%b",
                         m_axis_phase_tdata, m_axis_phase_tvalid);
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
        $dumpvars(0,clk, f0, rstn, m_axis_phase_tdata, m_axis_phase_tvalid);
    end

endmodule
