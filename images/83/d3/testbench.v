`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] a;
    reg [15:0] brk_addr;
    reg brk_ena;
    reg fclk;
    reg m1_n;
    reg mreq_n;
    reg rst_n;
    reg zneg;
    reg zpos;
    wire imm_nmi;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .brk_addr(brk_addr),
        .brk_ena(brk_ena),
        .fclk(fclk),
        .m1_n(m1_n),
        .mreq_n(mreq_n),
        .rst_n(rst_n),
        .zneg(zneg),
        .zpos(zpos),
        .imm_nmi(imm_nmi)
    );

    // Clock generation (10ns period)
    initial begin
        fclk = 0;
        forever #5 fclk = ~fclk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            a = 16'h0000;
            brk_addr = 16'h0000;
            brk_ena = 0;
            m1_n = 1;
            mreq_n = 1;
            zneg = 0;
            zpos = 0;
            @(posedge fclk);
            #1 rst_n = 1;
            @(posedge fclk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Initial state after reset", test_num);
            reset_dut();
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: All trigger conditions met", test_num);
            reset_dut();
            brk_ena = 1;
            brk_addr = 16'hABCD;
            a = 16'hABCD;
            zneg = 1;
            @(posedge fclk);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Address mismatch", test_num);
            reset_dut();
            brk_ena = 1;
            brk_addr = 16'hABCD;
            a = 16'h1234;
            zneg = 1;
            @(posedge fclk);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Break disabled", test_num);
            reset_dut();
            brk_ena = 0;
            brk_addr = 16'h5555;
            a = 16'h5555;
            zneg = 1;
            @(posedge fclk);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: zneg signal low", test_num);
            reset_dut();
            brk_ena = 1;
            brk_addr = 16'hAAAA;
            a = 16'hAAAA;
            zneg = 0;
            @(posedge fclk);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Reset override during valid conditions", test_num);
            reset_dut();
            brk_ena = 1;
            brk_addr = 16'h1111;
            a = 16'h1111;
            zneg = 1;
            @(posedge fclk);
            #1 rst_n = 0;
            @(posedge fclk);
            #2;
            #1;

            check_outputs(0);
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
        input expected_imm_nmi;
        begin
            if (expected_imm_nmi === (expected_imm_nmi ^ imm_nmi ^ expected_imm_nmi)) begin
                $display("PASS");
                $display("  Outputs: imm_nmi=%b",
                         imm_nmi);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: imm_nmi=%b",
                         expected_imm_nmi);
                $display("  Got:      imm_nmi=%b",
                         imm_nmi);
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
        $dumpvars(0,a, brk_addr, brk_ena, fclk, m1_n, mreq_n, rst_n, zneg, zpos, imm_nmi);
    end

endmodule
