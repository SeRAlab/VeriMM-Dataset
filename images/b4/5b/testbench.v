`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset_interface;
    reg rst_n;
    reg usr_arb_rx_data;
    reg usr_arb_rx_rd_tag;
    reg usr_arb_rx_rd_valid;
    reg usr_pipe_rx_data;
    reg usr_pipe_rx_rd_tag;
    reg usr_pipe_rx_rd_valid;
    wire [31:0] rx_data_reg;
    wire [31:0] rx_rd_tag_reg;
    wire rx_rd_valid_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset_interface(reset_interface),
        .rst_n(rst_n),
        .usr_arb_rx_data(usr_arb_rx_data),
        .usr_arb_rx_rd_tag(usr_arb_rx_rd_tag),
        .usr_arb_rx_rd_valid(usr_arb_rx_rd_valid),
        .usr_pipe_rx_data(usr_pipe_rx_data),
        .usr_pipe_rx_rd_tag(usr_pipe_rx_rd_tag),
        .usr_pipe_rx_rd_valid(usr_pipe_rx_rd_valid),
        .rx_data_reg(rx_data_reg),
        .rx_rd_tag_reg(rx_rd_tag_reg),
        .rx_rd_valid_reg(rx_rd_valid_reg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            reset_interface = 0;
            usr_arb_rx_rd_valid = 0;
            usr_arb_rx_rd_tag = 0;
            usr_arb_rx_data = 0;
            usr_pipe_rx_rd_valid = 0;
            usr_pipe_rx_rd_tag = 0;
            usr_pipe_rx_data = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Hardware Reset (rst_n)", test_num);
            reset_dut();


            #1;



            check_outputs(32'h0, 32'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Interface Reset", test_num);
            reset_dut();

            usr_arb_rx_rd_valid = 1;
            usr_arb_rx_rd_tag = 1;
            usr_arb_rx_data = 1;
            @(posedge clk);
            #1;

            reset_interface = 1;
            @(posedge clk);
            #1;
            reset_interface = 0;
            #1;

            check_outputs(32'h0, 32'h0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Select Arbiter Data (Arb Valid = 1)", test_num);
            reset_dut();
            usr_arb_rx_rd_valid = 1;
            usr_arb_rx_rd_tag = 1;
            usr_arb_rx_data = 1;
            usr_pipe_rx_rd_valid = 0;
            usr_pipe_rx_rd_tag = 0;
            usr_pipe_rx_data = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h1, 32'h1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Select Pipeline Data (Arb Valid = 0)", test_num);
            reset_dut();
            usr_arb_rx_rd_valid = 0;
            usr_arb_rx_rd_tag = 0;
            usr_arb_rx_data = 0;
            usr_pipe_rx_rd_valid = 1;
            usr_pipe_rx_rd_tag = 1;
            usr_pipe_rx_data = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h1, 32'h1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Arbiter Priority over Pipeline", test_num);
            reset_dut();

            usr_arb_rx_rd_valid = 1;
            usr_arb_rx_rd_tag = 0;
            usr_arb_rx_data = 0;
            usr_pipe_rx_rd_valid = 1;
            usr_pipe_rx_rd_tag = 1;
            usr_pipe_rx_data = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0, 32'h0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Pipeline selection when Arb Valid is 0", test_num);
            reset_dut();
            usr_arb_rx_rd_valid = 0;
            usr_arb_rx_data = 1;
            usr_pipe_rx_rd_valid = 0;
            usr_pipe_rx_data = 0;
            usr_pipe_rx_rd_tag = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0, 32'h0, 1'b0);
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
        input [31:0] expected_rx_data_reg;
        input [31:0] expected_rx_rd_tag_reg;
        input expected_rx_rd_valid_reg;
        begin
            if (expected_rx_data_reg === (expected_rx_data_reg ^ rx_data_reg ^ expected_rx_data_reg) &&
                expected_rx_rd_tag_reg === (expected_rx_rd_tag_reg ^ rx_rd_tag_reg ^ expected_rx_rd_tag_reg) &&
                expected_rx_rd_valid_reg === (expected_rx_rd_valid_reg ^ rx_rd_valid_reg ^ expected_rx_rd_valid_reg)) begin
                $display("PASS");
                $display("  Outputs: rx_data_reg=%h, rx_rd_tag_reg=%h, rx_rd_valid_reg=%b",
                         rx_data_reg, rx_rd_tag_reg, rx_rd_valid_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rx_data_reg=%h, rx_rd_tag_reg=%h, rx_rd_valid_reg=%b",
                         expected_rx_data_reg, expected_rx_rd_tag_reg, expected_rx_rd_valid_reg);
                $display("  Got:      rx_data_reg=%h, rx_rd_tag_reg=%h, rx_rd_valid_reg=%b",
                         rx_data_reg, rx_rd_tag_reg, rx_rd_valid_reg);
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
        $dumpvars(0,clk, reset_interface, rst_n, usr_arb_rx_data, usr_arb_rx_rd_tag, usr_arb_rx_rd_valid, usr_pipe_rx_data, usr_pipe_rx_rd_tag, usr_pipe_rx_rd_valid, rx_data_reg, rx_rd_tag_reg, rx_rd_valid_reg);
    end

endmodule
