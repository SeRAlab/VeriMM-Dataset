`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [63:0] s_axis_ireq_tdata;
    reg s_axis_ireq_tvalid;
    wire [63:0] m_axis_iresp_tdata;
    wire m_axis_iresp_tvalid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .s_axis_ireq_tdata(s_axis_ireq_tdata),
        .s_axis_ireq_tvalid(s_axis_ireq_tvalid),
        .m_axis_iresp_tdata(m_axis_iresp_tdata),
        .m_axis_iresp_tvalid(m_axis_iresp_tvalid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            s_axis_ireq_tvalid = 0;
            s_axis_ireq_tdata = 64'h0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Basic Math (10 * 5 + 2)", test_num);
            reset_dut();
            s_axis_ireq_tvalid = 1;
            s_axis_ireq_tdata = {32'd10, 16'd5, 16'd2};
            @(posedge clk);
            #1 s_axis_ireq_tvalid = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(64'd52, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Zero Inputs", test_num);
            reset_dut();
            s_axis_ireq_tvalid = 1;
            s_axis_ireq_tdata = 64'h0;
            @(posedge clk);
            #1 s_axis_ireq_tvalid = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(64'h0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Minimum Non-Zero", test_num);
            reset_dut();
            s_axis_ireq_tvalid = 1;
            s_axis_ireq_tdata = {32'd1, 16'd1, 16'd1};
            @(posedge clk);
            #1 s_axis_ireq_tvalid = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(64'h2, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Maximum Value Check", test_num);
            reset_dut();
            s_axis_ireq_tvalid = 1;
            s_axis_ireq_tdata = {32'hFFFFFFFF, 16'hFFFF, 16'hFFFF};

            @(posedge clk);
            #1 s_axis_ireq_tvalid = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(64'h0000FFFF00000000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Large Data Shift", test_num);
            reset_dut();
            s_axis_ireq_tvalid = 1;
            s_axis_ireq_tdata = {32'h12345678, 16'h0010, 16'h0001};
            @(posedge clk);
            #1 s_axis_ireq_tvalid = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(64'h0000000123456781, 1'b1);
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
        input [63:0] expected_m_axis_iresp_tdata;
        input expected_m_axis_iresp_tvalid;
        begin
            if (expected_m_axis_iresp_tdata === (expected_m_axis_iresp_tdata ^ m_axis_iresp_tdata ^ expected_m_axis_iresp_tdata) &&
                expected_m_axis_iresp_tvalid === (expected_m_axis_iresp_tvalid ^ m_axis_iresp_tvalid ^ expected_m_axis_iresp_tvalid)) begin
                $display("PASS");
                $display("  Outputs: m_axis_iresp_tdata=%h, m_axis_iresp_tvalid=%b",
                         m_axis_iresp_tdata, m_axis_iresp_tvalid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m_axis_iresp_tdata=%h, m_axis_iresp_tvalid=%b",
                         expected_m_axis_iresp_tdata, expected_m_axis_iresp_tvalid);
                $display("  Got:      m_axis_iresp_tdata=%h, m_axis_iresp_tvalid=%b",
                         m_axis_iresp_tdata, m_axis_iresp_tvalid);
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
        $dumpvars(0,clk, reset, s_axis_ireq_tdata, s_axis_ireq_tvalid, m_axis_iresp_tdata, m_axis_iresp_tvalid);
    end

endmodule
