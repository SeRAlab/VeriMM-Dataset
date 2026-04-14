`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ENA_I;
    reg ENB_I;
    reg POR_B;
    reg [63:0] Q;
    reg [3:0] RD_PNTR;
    reg [3:0] WR_PNTR;
    reg aclk;
    reg s_dclk_o;
    wire [63:0] D;
    wire p_20_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ENA_I(ENA_I),
        .ENB_I(ENB_I),
        .POR_B(POR_B),
        .Q(Q),
        .RD_PNTR(RD_PNTR),
        .WR_PNTR(WR_PNTR),
        .aclk(aclk),
        .s_dclk_o(s_dclk_o),
        .D(D),
        .p_20_out(p_20_out)
    );

    // Clock generation (10ns period)
    initial begin
        aclk = 0;
        forever #5 aclk = ~aclk;
    end

        task reset_dut;

        begin
            POR_B = 0;
            ENA_I = 0;
            ENB_I = 0;
            Q = 64'b0;
            RD_PNTR = 4'b0;
            WR_PNTR = 4'b0;
            s_dclk_o = 0;
            #20;
            POR_B = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            @(posedge aclk);
            ENA_I = 1;
            WR_PNTR = 4'h0;
            Q = 64'hAAAA_BBBB_CCCC_DDDD;

            @(posedge aclk);
            ENA_I = 0;


            @(posedge aclk);
            ENB_I = 1;
            RD_PNTR = 4'h0;

            @(posedge aclk);
            #1;
            #1;

            check_outputs(64'hAAAA_BBBB_CCCC_DDDD, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            @(posedge aclk);
            ENA_I = 1;
            WR_PNTR = 4'hF;
            Q = 64'h1234_5678_90AB_CDEF;

            @(posedge aclk);
            ENA_I = 0;


            @(posedge aclk);
            ENB_I = 1;
            RD_PNTR = 4'hF;

            @(posedge aclk);
            #1;
            #1;

            check_outputs(64'h1234_5678_90AB_CDEF, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            @(posedge aclk);
            ENA_I = 0;
            WR_PNTR = 4'h5;
            Q = 64'hDEAD_BEEF_DEAD_BEEF;

            @(posedge aclk);

            ENB_I = 1;
            RD_PNTR = 4'h5;

            @(posedge aclk);
            #1;

            #1;


            check_outputs(64'h0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            @(posedge aclk);
            ENA_I = 1;
            WR_PNTR = 4'h2;
            Q = 64'h5555_AAAA_5555_AAAA;
            @(posedge aclk);
            ENA_I = 0;


            @(posedge aclk);
            ENA_I = 1;
            WR_PNTR = 4'h3;
            Q = 64'hFFFF_0000_FFFF_0000;
            ENB_I = 1;
            RD_PNTR = 4'h2;

            @(posedge aclk);
            #1;

            #1;


            check_outputs(64'h5555_AAAA_5555_AAAA, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            @(posedge aclk);
            ENA_I = 1; WR_PNTR = 4'h1; Q = 64'h1;

            @(posedge aclk);
            ENA_I = 1; WR_PNTR = 4'h2; Q = 64'h2;

            @(posedge aclk);
            ENA_I = 1; WR_PNTR = 4'h3; Q = 64'h3;

            @(posedge aclk);
            ENA_I = 0;
            ENB_I = 1;
            RD_PNTR = 4'h2;

            @(posedge aclk);
            #1;
            #1;

            check_outputs(64'h2, 0);
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
        input [63:0] expected_D;
        input expected_p_20_out;
        begin
            if (expected_D === (expected_D ^ D ^ expected_D) &&
                expected_p_20_out === (expected_p_20_out ^ p_20_out ^ expected_p_20_out)) begin
                $display("PASS");
                $display("  Outputs: D=%h, p_20_out=%b",
                         D, p_20_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D=%h, p_20_out=%b",
                         expected_D, expected_p_20_out);
                $display("  Got:      D=%h, p_20_out=%b",
                         D, p_20_out);
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
        $dumpvars(0,ENA_I, ENB_I, POR_B, Q, RD_PNTR, WR_PNTR, aclk, s_dclk_o, D, p_20_out);
    end

endmodule
