`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg s_axi_aclk;
    reg sda_i;
    reg sda_rin_d1;
    wire detect_stop_b_reg;
    wire scndry_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .s_axi_aclk(s_axi_aclk),
        .sda_i(sda_i),
        .sda_rin_d1(sda_rin_d1),
        .detect_stop_b_reg(detect_stop_b_reg),
        .scndry_out(scndry_out)
    );

    // Clock generation (10ns period)
    initial begin
        s_axi_aclk = 0;
        forever #5 s_axi_aclk = ~s_axi_aclk;
    end

        task reset_dut;

    begin
        sda_i = 1'b1;
        sda_rin_d1 = 1'b1;
        repeat(5) @(posedge s_axi_aclk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        sda_i = 1'b1;
        sda_rin_d1 = 1'b1;
        repeat(2) @(posedge s_axi_aclk);

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        sda_i = 1'b0;
        repeat(5) @(posedge s_axi_aclk);

        #1;


        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();

        sda_i = 1'b0;
        sda_rin_d1 = 1'b1;
        repeat(5) @(posedge s_axi_aclk);

        sda_i = 1'b1;
        repeat(3) @(posedge s_axi_aclk);

        #1;


        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        sda_i = 1'b1;
        sda_rin_d1 = 1'b1;
        repeat(5) @(posedge s_axi_aclk);
        sda_i = 1'b0;
        repeat(3) @(posedge s_axi_aclk);

        #1;


        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        sda_i = 1'b0;
        sda_rin_d1 = 1'b0;
        repeat(5) @(posedge s_axi_aclk);
        sda_i = 1'b1;
        repeat(3) @(posedge s_axi_aclk);

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        sda_i = 1'b0;
        sda_rin_d1 = 1'b1;
        repeat(5) @(posedge s_axi_aclk);
        sda_i = 1'b1;
        repeat(1) @(posedge s_axi_aclk);

        repeat(2) @(posedge s_axi_aclk);
        #1;

        check_outputs(1'b1, 1'b1);
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
        input expected_detect_stop_b_reg;
        input expected_scndry_out;
        begin
            if (expected_detect_stop_b_reg === (expected_detect_stop_b_reg ^ detect_stop_b_reg ^ expected_detect_stop_b_reg) &&
                expected_scndry_out === (expected_scndry_out ^ scndry_out ^ expected_scndry_out)) begin
                $display("PASS");
                $display("  Outputs: detect_stop_b_reg=%b, scndry_out=%b",
                         detect_stop_b_reg, scndry_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: detect_stop_b_reg=%b, scndry_out=%b",
                         expected_detect_stop_b_reg, expected_scndry_out);
                $display("  Got:      detect_stop_b_reg=%b, scndry_out=%b",
                         detect_stop_b_reg, scndry_out);
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
        $dumpvars(0,s_axi_aclk, sda_i, sda_rin_d1, detect_stop_b_reg, scndry_out);
    end

endmodule
