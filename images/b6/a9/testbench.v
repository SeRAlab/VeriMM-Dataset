`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [174:0] d_flits_m;
    reg mem_done_access;
    reg rst;
    reg v_d_flits_m;
    wire [174:0] d_m_areg_flits;
    wire d_m_cstate;

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
        .d_m_cstate(d_m_cstate)
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
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic Flit Capture", test_num);

            v_d_flits_m = 1;
            d_flits_m = 175'hA5A5A5A5_5A5A5A5A_A5A5A5A5_5A5A5A5A_A5A5;
            @(posedge clk);
            #1;
            v_d_flits_m = 0;

            #1;


            check_outputs(175'hA5A5A5A5_5A5A5A5A_A5A5A5A5_5A5A5A5A_A5A5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Clear using mem_done_access", test_num);


            v_d_flits_m = 1;
            d_flits_m = 175'h12345678_9ABCDEF0_12345678_9ABCDEF0_1234;
            @(posedge clk);
            #1;
            v_d_flits_m = 0;


            mem_done_access = 1;
            @(posedge clk);
            #1;
            mem_done_access = 0;


            #1;



            check_outputs(175'd0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Overwrite Prevention", test_num);


            v_d_flits_m = 1;
            d_flits_m = 175'hDEADBEEF_DEADBEEF_DEADBEEF_DEADBEEF_DE;
            @(posedge clk);
            #1;


            v_d_flits_m = 1;
            d_flits_m = 175'hCAFEBABE_CAFEBABE_CAFEBABE_CAFEBABE_CA;
            @(posedge clk);
            #1;
            v_d_flits_m = 0;


            #1;



            check_outputs(175'hDEADBEEF_DEADBEEF_DEADBEEF_DEADBEEF_DE, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Reset during operation", test_num);


            v_d_flits_m = 1;
            d_flits_m = 175'hFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF_FF;
            @(posedge clk);
            #1;


            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;

            #1;


            check_outputs(175'd0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Rapid Reuse", test_num);


            v_d_flits_m = 1;
            d_flits_m = 175'hAAAAA_AAAAA_AAAAA_AAAAA_AAAAA_AAAAA;
            @(posedge clk);
            #1;


            v_d_flits_m = 0;
            mem_done_access = 1;
            @(posedge clk);
            #1;


            mem_done_access = 0;
            v_d_flits_m = 1;
            d_flits_m = 175'hBBBBB_BBBBB_BBBBB_BBBBB_BBBBB_BBBBB;
            @(posedge clk);
            #1;
            v_d_flits_m = 0;

            #1;


            check_outputs(175'hBBBBB_BBBBB_BBBBB_BBBBB_BBBBB_BBBBB, 1'b1);
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
        input [174:0] expected_d_m_areg_flits;
        input expected_d_m_cstate;
        begin
            if (expected_d_m_areg_flits === (expected_d_m_areg_flits ^ d_m_areg_flits ^ expected_d_m_areg_flits) &&
                expected_d_m_cstate === (expected_d_m_cstate ^ d_m_cstate ^ expected_d_m_cstate)) begin
                $display("PASS");
                $display("  Outputs: d_m_areg_flits=%h, d_m_cstate=%b",
                         d_m_areg_flits, d_m_cstate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_m_areg_flits=%h, d_m_cstate=%b",
                         expected_d_m_areg_flits, expected_d_m_cstate);
                $display("  Got:      d_m_areg_flits=%h, d_m_cstate=%b",
                         d_m_areg_flits, d_m_cstate);
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
        $dumpvars(0,clk, d_flits_m, mem_done_access, rst, v_d_flits_m, d_m_areg_flits, d_m_cstate);
    end

endmodule
