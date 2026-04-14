`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg I1;
    reg rst_d2;
    reg rst_full_gen_i;
    reg [4:0] v1_reg;
    reg [3:0] v1_reg_0;
    reg wr_clk;
    reg wr_en;
    wire E;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I1(I1),
        .rst_d2(rst_d2),
        .rst_full_gen_i(rst_full_gen_i),
        .v1_reg(v1_reg),
        .v1_reg_0(v1_reg_0),
        .wr_clk(wr_clk),
        .wr_en(wr_en),
        .E(E),
        .full(full)
    );

    // Clock generation (10ns period)
    initial begin
        wr_clk = 0;
        forever #5 wr_clk = ~wr_clk;
    end

        task reset_dut;

        begin
            rst_d2 = 1;
            rst_full_gen_i = 1;
            wr_en = 0;
            v1_reg = 5'd0;
            v1_reg_0 = 4'd0;
            I1 = 1'b0;
            repeat(2) @(posedge wr_clk);
            #1;
            rst_d2 = 0;
            rst_full_gen_i = 0;
            repeat(2) @(posedge wr_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            v1_reg = 5'd0;
            v1_reg_0 = 4'd0;
            wr_en = 0;
            repeat(2) @(posedge wr_clk);
            #1;
            $display("Testcase 001: Reset/Empty State");
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            v1_reg = 5'd1;
            v1_reg_0 = 4'd0;
            wr_en = 1;
            I1 = 1'b1;
            repeat(2) @(posedge wr_clk);
            #1;
            $display("Testcase 002: Single Entry State");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            v1_reg = 5'd16;
            v1_reg_0 = 4'd0;
            wr_en = 0;
            repeat(2) @(posedge wr_clk);
            #1;
            $display("Testcase 003: Full State (16 entries)");
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            v1_reg = 5'd17;
            v1_reg_0 = 4'd1;
            wr_en = 0;
            repeat(2) @(posedge wr_clk);
            #1;
            $display("Testcase 004: Wrap-around Full State");
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();




            v1_reg = 5'd0;
            v1_reg_0 = 4'd0;
            repeat(2) @(posedge wr_clk);
            #1;
            $display("Testcase 005: Empty State after wrap");
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            v1_reg = 5'd16;
            v1_reg_0 = 4'd0;

            rst_full_gen_i = 1;
            repeat(2) @(posedge wr_clk);
            #1;
            $display("Testcase 006: Full Reset Override");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();

            v1_reg = 5'd8;
            v1_reg_0 = 4'd0;
            repeat(2) @(posedge wr_clk);
            #1;
            $display("Testcase 007: Half-Full State");
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_E;
        input expected_full;
        begin
            if (expected_E === (expected_E ^ E ^ expected_E) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: E=%b, full=%b",
                         E, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: E=%b, full=%b",
                         expected_E, expected_full);
                $display("  Got:      E=%b, full=%b",
                         E, full);
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
        $dumpvars(0,I1, rst_d2, rst_full_gen_i, v1_reg, v1_reg_0, wr_clk, wr_en, E, full);
    end

endmodule
