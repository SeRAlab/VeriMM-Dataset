`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] D;
    reg m_aclk;
    reg rd_rst_reg_reg;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .m_aclk(m_aclk),
        .rd_rst_reg_reg(rd_rst_reg_reg),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        m_aclk = 0;
        forever #5 m_aclk = ~m_aclk;
    end

        task reset_dut;

        begin
            rd_rst_reg_reg = 1;
            D = 4'b0000;
            #15;
            rd_rst_reg_reg = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset Verification");
            reset_dut();

            D = 4'hA;
            #2;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Basic Capture");
            reset_dut();
            D = 4'h5;
            @(posedge m_aclk);
            #2;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Sequential Data Capture");
            reset_dut();
            D = 4'h1;
            @(posedge m_aclk);
            #2;
            D = 4'hE;
            @(posedge m_aclk);
            #2;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Asynchronous Reset Check");
            reset_dut();
            D = 4'hF;
            @(posedge m_aclk);
            #2;

            rd_rst_reg_reg = 1;
            #2;
            #1;

            check_outputs(4'h0);
            rd_rst_reg_reg = 0;
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Reset Dominance");
            reset_dut();
            rd_rst_reg_reg = 1;
            D = 4'h9;
            @(posedge m_aclk);
            #2;

            #1;


            check_outputs(4'h0);
            rd_rst_reg_reg = 0;
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Max to Min Transition");
            reset_dut();
            D = 4'hF;
            @(posedge m_aclk);
            #2;
            D = 4'h0;
            @(posedge m_aclk);
            #2;
            #1;

            check_outputs(4'h0);
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D, m_aclk, rd_rst_reg_reg, Q);
    end

endmodule
