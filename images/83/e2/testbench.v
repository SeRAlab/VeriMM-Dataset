`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] s_axis_tdata;
    reg s_axis_tvalid;
    wire [7:0] addr;
    wire [2:0] cycle_index;
    wire first_cycle;
    wire last_cycle;
    wire [31:0] m_axis_tdata;
    wire m_axis_tvalid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .s_axis_tdata(s_axis_tdata),
        .s_axis_tvalid(s_axis_tvalid),
        .addr(addr),
        .cycle_index(cycle_index),
        .first_cycle(first_cycle),
        .last_cycle(last_cycle),
        .m_axis_tdata(m_axis_tdata),
        .m_axis_tvalid(m_axis_tvalid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            s_axis_tvalid <= 0;
            s_axis_tdata <= 0;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();

            s_axis_tdata = {16'd2, 16'd4};
            s_axis_tvalid = 1;
            @(posedge clk);
            #1;
            s_axis_tvalid = 0;

            repeat(8 - 1) @(posedge clk);
            #1;

            #1;


            check_outputs(8'd3, 3'd1, 1'b0, 1'b1, 32'h00020004, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            s_axis_tdata = {16'd4, 16'd2};
            s_axis_tvalid = 1;
            @(posedge clk);
            #1;
            s_axis_tvalid = 0;

            repeat(8 - 1) @(posedge clk);
            #1;

            #1;


            check_outputs(8'd1, 3'd3, 1'b0, 1'b1, 32'h00040002, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            s_axis_tdata = {16'd1, 16'd6};
            s_axis_tvalid = 1;
            @(posedge clk);
            #1;
            s_axis_tvalid = 0;

            repeat(6 - 1) @(posedge clk);
            #1;

            #1;


            check_outputs(8'd5, 3'd0, 1'b1, 1'b1, 32'h00010006, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            s_axis_tdata = {16'd3, 16'd10};
            s_axis_tvalid = 1;
            @(posedge clk);
            #1;
            s_axis_tvalid = 0;

            repeat(30 - 1) @(posedge clk);
            #1;

            #1;


            check_outputs(8'd9, 3'd2, 1'b0, 1'b1, 32'h0003000A, 1'b0);
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
        input [7:0] expected_addr;
        input [2:0] expected_cycle_index;
        input expected_first_cycle;
        input expected_last_cycle;
        input [31:0] expected_m_axis_tdata;
        input expected_m_axis_tvalid;
        begin
            if (expected_addr === (expected_addr ^ addr ^ expected_addr) &&
                expected_cycle_index === (expected_cycle_index ^ cycle_index ^ expected_cycle_index) &&
                expected_first_cycle === (expected_first_cycle ^ first_cycle ^ expected_first_cycle) &&
                expected_last_cycle === (expected_last_cycle ^ last_cycle ^ expected_last_cycle) &&
                expected_m_axis_tdata === (expected_m_axis_tdata ^ m_axis_tdata ^ expected_m_axis_tdata) &&
                expected_m_axis_tvalid === (expected_m_axis_tvalid ^ m_axis_tvalid ^ expected_m_axis_tvalid)) begin
                $display("PASS");
                $display("  Outputs: addr=%h, cycle_index=%h, first_cycle=%b, last_cycle=%b, m_axis_tdata=%h, m_axis_tvalid=%b",
                         addr, cycle_index, first_cycle, last_cycle, m_axis_tdata, m_axis_tvalid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr=%h, cycle_index=%h, first_cycle=%b, last_cycle=%b, m_axis_tdata=%h, m_axis_tvalid=%b",
                         expected_addr, expected_cycle_index, expected_first_cycle, expected_last_cycle, expected_m_axis_tdata, expected_m_axis_tvalid);
                $display("  Got:      addr=%h, cycle_index=%h, first_cycle=%b, last_cycle=%b, m_axis_tdata=%h, m_axis_tvalid=%b",
                         addr, cycle_index, first_cycle, last_cycle, m_axis_tdata, m_axis_tvalid);
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
        $dumpvars(0,clk, s_axis_tdata, s_axis_tvalid, addr, cycle_index, first_cycle, last_cycle, m_axis_tdata, m_axis_tvalid);
    end

endmodule
