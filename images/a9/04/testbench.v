`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dc_done_access;
    reg [143:0] m_flits_d;
    reg rst;
    reg v_m_flits_d;
    wire [143:0] flits_reg;
    wire [143:0] m_d_areg_flits;
    wire m_d_cstate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dc_done_access(dc_done_access),
        .m_flits_d(m_flits_d),
        .rst(rst),
        .v_m_flits_d(v_m_flits_d),
        .flits_reg(flits_reg),
        .m_d_areg_flits(m_d_areg_flits),
        .m_d_cstate(m_d_cstate)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            dc_done_access = 0;
            v_m_flits_d = 0;
            m_flits_d = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(144'h0, 144'h0, 1'b0);
        end
        endtask

    task testcase002;

        reg [143:0] data;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Capture Valid Flit", test_num);
            reset_dut();
            data = 144'hAAAA_BBBB_CCCC_DDDD_EEEE_FFFF_1234_5678_90AB;

            v_m_flits_d = 1'b1;
            m_flits_d = data;
            @(posedge clk);
            #1;

            #1;


            check_outputs(data, data, 1'b1);
        end
        endtask

    task testcase003;

        reg [143:0] data;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Clear via dc_done_access", test_num);
            reset_dut();
            data = 144'h1111_2222_3333_4444_5555_6666_7777_8888_9999;


            v_m_flits_d = 1'b1;
            m_flits_d = data;
            @(posedge clk);
            #1;


            v_m_flits_d = 1'b0;
            dc_done_access = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(144'h0, 144'h0, 1'b0);
        end
        endtask

    task testcase004;

        reg [143:0] data;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority Check (Done vs Valid)", test_num);
            reset_dut();
            data = 144'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;


            dc_done_access = 1'b1;
            v_m_flits_d = 1'b1;
            m_flits_d = data;
            @(posedge clk);
            #1;

            #1;


            check_outputs(144'h0, 144'h0, 1'b0);
        end
        endtask

    task testcase005;

        reg [143:0] data;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Hold Data Persistence", test_num);
            reset_dut();
            data = 144'h5555_AAAA_5555_AAAA_5555_AAAA_5555_AAAA_5555;


            v_m_flits_d = 1'b1;
            m_flits_d = data;
            @(posedge clk);
            #1;


            v_m_flits_d = 1'b0;
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(data, data, 1'b1);
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
        input [143:0] expected_flits_reg;
        input [143:0] expected_m_d_areg_flits;
        input expected_m_d_cstate;
        begin
            if (expected_flits_reg === (expected_flits_reg ^ flits_reg ^ expected_flits_reg) &&
                expected_m_d_areg_flits === (expected_m_d_areg_flits ^ m_d_areg_flits ^ expected_m_d_areg_flits) &&
                expected_m_d_cstate === (expected_m_d_cstate ^ m_d_cstate ^ expected_m_d_cstate)) begin
                $display("PASS");
                $display("  Outputs: flits_reg=%h, m_d_areg_flits=%h, m_d_cstate=%b",
                         flits_reg, m_d_areg_flits, m_d_cstate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: flits_reg=%h, m_d_areg_flits=%h, m_d_cstate=%b",
                         expected_flits_reg, expected_m_d_areg_flits, expected_m_d_cstate);
                $display("  Got:      flits_reg=%h, m_d_areg_flits=%h, m_d_cstate=%b",
                         flits_reg, m_d_areg_flits, m_d_cstate);
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
        $dumpvars(0,clk, dc_done_access, m_flits_d, rst, v_m_flits_d, flits_reg, m_d_areg_flits, m_d_cstate);
    end

endmodule
