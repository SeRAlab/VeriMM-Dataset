`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [31:0] f_icb_cmd_addr;
    reg f_icb_cmd_read;
    reg f_icb_cmd_valid;
    reg [31:0] f_icb_cmd_wdata;
    reg f_icb_rsp_ready;
    reg [31:0] i_icb_cmd_addr;
    reg i_icb_cmd_read;
    reg i_icb_cmd_valid;
    reg [31:0] i_icb_cmd_wdata;
    reg i_icb_rsp_ready;
    reg rst_n;
    wire f_icb_cmd_ready;
    wire [31:0] f_icb_rsp_rdata;
    wire f_icb_rsp_valid;
    wire i_icb_cmd_ready;
    wire [31:0] i_icb_rsp_rdata;
    wire i_icb_rsp_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .f_icb_cmd_addr(f_icb_cmd_addr),
        .f_icb_cmd_read(f_icb_cmd_read),
        .f_icb_cmd_valid(f_icb_cmd_valid),
        .f_icb_cmd_wdata(f_icb_cmd_wdata),
        .f_icb_rsp_ready(f_icb_rsp_ready),
        .i_icb_cmd_addr(i_icb_cmd_addr),
        .i_icb_cmd_read(i_icb_cmd_read),
        .i_icb_cmd_valid(i_icb_cmd_valid),
        .i_icb_cmd_wdata(i_icb_cmd_wdata),
        .i_icb_rsp_ready(i_icb_rsp_ready),
        .rst_n(rst_n),
        .f_icb_cmd_ready(f_icb_cmd_ready),
        .f_icb_rsp_rdata(f_icb_rsp_rdata),
        .f_icb_rsp_valid(f_icb_rsp_valid),
        .i_icb_cmd_ready(i_icb_cmd_ready),
        .i_icb_rsp_rdata(i_icb_rsp_rdata),
        .i_icb_rsp_valid(i_icb_rsp_valid)
    );
    task reset_system;

        begin
            rst_n = 0;
            i_icb_cmd_valid = 0;
            i_icb_cmd_addr = 0;
            i_icb_cmd_read = 0;
            i_icb_cmd_wdata = 0;
            i_icb_rsp_ready = 0;
            f_icb_cmd_valid = 0;
            f_icb_cmd_addr = 0;
            f_icb_cmd_read = 0;
            f_icb_cmd_wdata = 0;
            f_icb_rsp_ready = 0;
            repeat(2) @(posedge clk);
            rst_n = 1;
            @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Basic Reset and Default State Check", test_num);

            rst_n = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 32'h0, 0, 0, 32'h0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: i_icb Interface Stimulus Check", test_num);
            reset_system();


            i_icb_cmd_valid = 1;
            i_icb_cmd_addr = 32'hA5A5A5A5;
            i_icb_cmd_read = 1;
            i_icb_rsp_ready = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 32'h0, 0, 0, 32'h0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: f_icb Interface Stimulus Check", test_num);
            reset_system();


            f_icb_cmd_valid = 1;
            f_icb_cmd_addr = 32'h12345678;
            f_icb_cmd_wdata = 32'hDEADBEEF;
            f_icb_cmd_read = 0;
            f_icb_rsp_ready = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 32'h0, 0, 0, 32'h0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Simultaneous Interface Stimulus Check", test_num);
            reset_system();


            i_icb_cmd_valid = 1;
            i_icb_cmd_addr = 32'hFFFFFFFF;
            f_icb_cmd_valid = 1;
            f_icb_cmd_addr = 32'hEEEEEEEE;
            i_icb_rsp_ready = 1;
            f_icb_rsp_ready = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 32'h0, 0, 0, 32'h0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Post-Reset Verification", test_num);
            reset_system();


            i_icb_cmd_addr = 32'h5555AAAA;
            f_icb_cmd_wdata = 32'hAA55AA55;


            rst_n = 0;
            repeat(5) @(posedge clk);

            #1;

            #1;


            check_outputs(0, 32'h0, 0, 0, 32'h0, 0);
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
        input expected_f_icb_cmd_ready;
        input [31:0] expected_f_icb_rsp_rdata;
        input expected_f_icb_rsp_valid;
        input expected_i_icb_cmd_ready;
        input [31:0] expected_i_icb_rsp_rdata;
        input expected_i_icb_rsp_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_f_icb_cmd_ready === (expected_f_icb_cmd_ready ^ f_icb_cmd_ready ^ expected_f_icb_cmd_ready) &&
                expected_f_icb_rsp_rdata === (expected_f_icb_rsp_rdata ^ f_icb_rsp_rdata ^ expected_f_icb_rsp_rdata) &&
                expected_f_icb_rsp_valid === (expected_f_icb_rsp_valid ^ f_icb_rsp_valid ^ expected_f_icb_rsp_valid) &&
                expected_i_icb_cmd_ready === (expected_i_icb_cmd_ready ^ i_icb_cmd_ready ^ expected_i_icb_cmd_ready) &&
                expected_i_icb_rsp_rdata === (expected_i_icb_rsp_rdata ^ i_icb_rsp_rdata ^ expected_i_icb_rsp_rdata) &&
                expected_i_icb_rsp_valid === (expected_i_icb_rsp_valid ^ i_icb_rsp_valid ^ expected_i_icb_rsp_valid)) begin
                $display("PASS");
                $display("  Outputs: f_icb_cmd_ready=%b, f_icb_rsp_rdata=%h, f_icb_rsp_valid=%b, i_icb_cmd_ready=%b, i_icb_rsp_rdata=%h, i_icb_rsp_valid=%b",
                         f_icb_cmd_ready, f_icb_rsp_rdata, f_icb_rsp_valid, i_icb_cmd_ready, i_icb_rsp_rdata, i_icb_rsp_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: f_icb_cmd_ready=%b, f_icb_rsp_rdata=%h, f_icb_rsp_valid=%b, i_icb_cmd_ready=%b, i_icb_rsp_rdata=%h, i_icb_rsp_valid=%b",
                         expected_f_icb_cmd_ready, expected_f_icb_rsp_rdata, expected_f_icb_rsp_valid, expected_i_icb_cmd_ready, expected_i_icb_rsp_rdata, expected_i_icb_rsp_valid);
                $display("  Got:      f_icb_cmd_ready=%b, f_icb_rsp_rdata=%h, f_icb_rsp_valid=%b, i_icb_cmd_ready=%b, i_icb_rsp_rdata=%h, i_icb_rsp_valid=%b",
                         f_icb_cmd_ready, f_icb_rsp_rdata, f_icb_rsp_valid, i_icb_cmd_ready, i_icb_rsp_rdata, i_icb_rsp_valid);
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

endmodule
