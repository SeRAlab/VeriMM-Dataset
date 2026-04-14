`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg E;
    reg Q;
    reg clk;
    reg [8:0] count_d1_reg;
    reg [8:0] count_d1_reg_gcc;
    reg [23:0] din;
    reg tmp_ram_rd_en;
    wire [23:0] D;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .E(E),
        .Q(Q),
        .clk(clk),
        .count_d1_reg(count_d1_reg),
        .count_d1_reg_gcc(count_d1_reg_gcc),
        .din(din),
        .tmp_ram_rd_en(tmp_ram_rd_en),
        .D(D)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            Q = 1'b1;
            E = 1'b1;
            tmp_ram_rd_en = 1'b0;
            din = 24'h0;
            count_d1_reg = 9'h0;
            count_d1_reg_gcc = 9'h0;
            @(posedge clk);
            #1;
            Q = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Single Write then Read...");
            reset_dut();


            din = 24'hABCDEF;
            tmp_ram_rd_en = 1'b1;
            @(posedge clk);
            #1;
            tmp_ram_rd_en = 1'b0;


            E = 1'b0;
            @(posedge clk);
            #1;
            E = 1'b1;

            #1;


            check_outputs(24'hABCDEF);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Multiple Writes then Sequential Reads...");
            reset_dut();


            din = 24'h111111; tmp_ram_rd_en = 1'b1; @(posedge clk); #1;
            din = 24'h222222; tmp_ram_rd_en = 1'b1; @(posedge clk); #1;
            din = 24'h333333; tmp_ram_rd_en = 1'b1; @(posedge clk); #1;
            tmp_ram_rd_en = 1'b0;


            E = 1'b0; @(posedge clk); #1;
            E = 1'b0; @(posedge clk); #1;
            E = 1'b0; @(posedge clk); #1;
            E = 1'b1;

            #1;


            check_outputs(24'h333333);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Interleaved Write and Read...");
            reset_dut();


            din = 24'h555555; tmp_ram_rd_en = 1'b1; @(posedge clk); #1;
            tmp_ram_rd_en = 1'b0;


            E = 1'b0; @(posedge clk); #1;
            E = 1'b1;


            din = 24'hAAAAAA; tmp_ram_rd_en = 1'b1; @(posedge clk); #1;
            tmp_ram_rd_en = 1'b0;


            E = 1'b0; @(posedge clk); #1;
            E = 1'b1;

            #1;


            check_outputs(24'hAAAAAA);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Checking status bit influences...");
            reset_dut();


            count_d1_reg = 9'h010;
            count_d1_reg_gcc = 9'h010;


            din = 24'h998877;
            tmp_ram_rd_en = 1'b1;
            @(posedge clk);
            #1;
            tmp_ram_rd_en = 1'b0;


            E = 1'b0;
            @(posedge clk);
            #1;
            E = 1'b1;

            #1;


            check_outputs(24'h998877);
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
        input [23:0] expected_D;
        begin
            if (expected_D === (expected_D ^ D ^ expected_D)) begin
                $display("PASS");
                $display("  Outputs: D=%h",
                         D);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D=%h",
                         expected_D);
                $display("  Got:      D=%h",
                         D);
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
        $dumpvars(0,E, Q, clk, count_d1_reg, count_d1_reg_gcc, din, tmp_ram_rd_en, D);
    end

endmodule
