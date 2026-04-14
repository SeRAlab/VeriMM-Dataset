`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dc_done_access;
    reg [143:0] m_flits_d;
    reg rst;
    reg v_m_flits_d;
    wire [143:0] m_d_areg_flits;
    wire m_d_areg_state;
    wire v_m_d_areg_flits;

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
        .m_d_areg_flits(m_d_areg_flits),
        .m_d_areg_state(m_d_areg_state),
        .v_m_d_areg_flits(v_m_d_areg_flits)
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
            m_flits_d = 144'b0;
            v_m_flits_d = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(144'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: Capture 144-bit Data", test_num);
            reset_dut();
            m_flits_d = 144'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            v_m_flits_d = 1;
            @(posedge clk);
            #2 v_m_flits_d = 0;

            #1;


            check_outputs(144'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: Data Retention (v_m_flits_d goes low)", test_num);
            reset_dut();
            m_flits_d = 144'h555555555555555555555555555555555555;
            v_m_flits_d = 1;
            @(posedge clk);
            #2 v_m_flits_d = 0;
            m_flits_d = 144'h0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(144'h555555555555555555555555555555555555, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %03d: Done Access Clear", test_num);
            reset_dut();

            m_flits_d = 144'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            v_m_flits_d = 1;
            @(posedge clk);
            #2 v_m_flits_d = 0;
            dc_done_access = 1;
            @(posedge clk);
            #2 dc_done_access = 0;

            #1;


            check_outputs(144'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %03d: Update Register with New Data", test_num);
            reset_dut();

            m_flits_d = 144'h111111111111111111111111111111111111;
            v_m_flits_d = 1;
            @(posedge clk);
            #2;

            m_flits_d = 144'hBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB;
            v_m_flits_d = 1;
            @(posedge clk);
            #2 v_m_flits_d = 0;

            #1;


            check_outputs(144'hBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %03d: Mid-operation Reset", test_num);
            reset_dut();
            m_flits_d = 144'hDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEAD;
            v_m_flits_d = 1;
            @(posedge clk);
            #2 rst = 1;
            @(posedge clk);
            #2 rst = 0;

            #1;


            check_outputs(144'h0, 1'b0, 1'b0);
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
        input [143:0] expected_m_d_areg_flits;
        input expected_m_d_areg_state;
        input expected_v_m_d_areg_flits;
        begin
            if (expected_m_d_areg_flits === (expected_m_d_areg_flits ^ m_d_areg_flits ^ expected_m_d_areg_flits) &&
                expected_m_d_areg_state === (expected_m_d_areg_state ^ m_d_areg_state ^ expected_m_d_areg_state) &&
                expected_v_m_d_areg_flits === (expected_v_m_d_areg_flits ^ v_m_d_areg_flits ^ expected_v_m_d_areg_flits)) begin
                $display("PASS");
                $display("  Outputs: m_d_areg_flits=%h, m_d_areg_state=%b, v_m_d_areg_flits=%b",
                         m_d_areg_flits, m_d_areg_state, v_m_d_areg_flits);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m_d_areg_flits=%h, m_d_areg_state=%b, v_m_d_areg_flits=%b",
                         expected_m_d_areg_flits, expected_m_d_areg_state, expected_v_m_d_areg_flits);
                $display("  Got:      m_d_areg_flits=%h, m_d_areg_state=%b, v_m_d_areg_flits=%b",
                         m_d_areg_flits, m_d_areg_state, v_m_d_areg_flits);
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
        $dumpvars(0,clk, dc_done_access, m_flits_d, rst, v_m_flits_d, m_d_areg_flits, m_d_areg_state, v_m_d_areg_flits);
    end

endmodule
