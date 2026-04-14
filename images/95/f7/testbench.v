`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] ir_low;
    reg ld_pc;
    reg ld_rat;
    reg pc_at;
    reg rst_n;
    reg [7:0] rx_low;
    wire [7:0] m_at;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ir_low(ir_low),
        .ld_pc(ld_pc),
        .ld_rat(ld_rat),
        .pc_at(pc_at),
        .rst_n(rst_n),
        .rx_low(rx_low),
        .m_at(m_at)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            ir_low = 8'h0;
            rx_low = 8'h0;
            ld_rat = 0;
            ld_pc = 0;
            pc_at = 0;
            @(negedge clk);
            rst_n = 1;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            pc_at = 1;
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            ir_low = 8'h12;
            rx_low = 8'h34;
            ld_rat = 1;
            @(posedge clk);
            #1;
            ld_rat = 0;
            pc_at = 0;
            #1;

            check_outputs(8'h46);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            ld_rat = 1;
            @(posedge clk);
            #1;
            ld_rat = 0;
            pc_at = 1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            ld_pc = 1;
            @(posedge clk);
            #1;
            ld_pc = 0;
            pc_at = 1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            ir_low = 8'hFF;
            rx_low = 8'h02;
            ld_rat = 1;
            @(posedge clk);
            #1;
            ld_rat = 0;
            pc_at = 0;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            ld_pc = 1;
            repeat(5) @(posedge clk);
            #1;
            ld_pc = 0;
            pc_at = 1;
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            ir_low = 8'hAA;
            rx_low = 8'h00;
            ld_rat = 1;
            @(posedge clk);
            #1;
            ld_rat = 0;
            pc_at = 0;
            #1;
            pc_at = 1;
            #1;
            #1;

            check_outputs(8'h01);
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
        testcase007();
        
        
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
        input [7:0] expected_m_at;
        begin
            if (expected_m_at === (expected_m_at ^ m_at ^ expected_m_at)) begin
                $display("PASS");
                $display("  Outputs: m_at=%h",
                         m_at);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m_at=%h",
                         expected_m_at);
                $display("  Got:      m_at=%h",
                         m_at);
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
        $dumpvars(0,clk, ir_low, ld_pc, ld_rat, pc_at, rst_n, rx_low, m_at);
    end

endmodule
