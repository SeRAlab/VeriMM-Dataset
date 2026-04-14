`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg pexc_ack_o;
    reg [31:0] pexc_dat_o;
    reg pexc_stall_o;
    reg pmain_ack_o;
    reg [31:0] pmain_dat_o;
    reg pmain_stall_o;
    reg [31:0] pmem_adr_o;
    reg pmem_cyc_o;
    reg pmem_stb_o;
    reg rst;
    wire pmem_ack_i;
    wire [31:0] pmem_dat_i;
    wire pmem_stall_i;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pexc_ack_o(pexc_ack_o),
        .pexc_dat_o(pexc_dat_o),
        .pexc_stall_o(pexc_stall_o),
        .pmain_ack_o(pmain_ack_o),
        .pmain_dat_o(pmain_dat_o),
        .pmain_stall_o(pmain_stall_o),
        .pmem_adr_o(pmem_adr_o),
        .pmem_cyc_o(pmem_cyc_o),
        .pmem_stb_o(pmem_stb_o),
        .rst(rst),
        .pmem_ack_i(pmem_ack_i),
        .pmem_dat_i(pmem_dat_i),
        .pmem_stall_i(pmem_stall_i)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            pmem_adr_o = 0;
            pmem_cyc_o = 0;
            pmem_stb_o = 0;
            pmain_dat_o = 0;
            pexc_dat_o = 0;
            pmain_ack_o = 0;
            pexc_ack_o = 0;
            pmain_stall_o = 0;
            pexc_stall_o = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            pmem_adr_o = 32'h0000_1000;
            pmem_cyc_o = 1;
            pmem_stb_o = 1;
            pmain_dat_o = 32'hABCD_1234;
            pmain_ack_o = 1;

            @(posedge clk);
            #2;

            $display("Testcase 001: Main Memory Read Access");
            #1;

            check_outputs(1'b1, 32'hABCD_1234, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            pmem_adr_o = 32'h8000_0000;
            pmem_cyc_o = 1;
            pmem_stb_o = 1;
            pexc_dat_o = 32'h55AA_CC33;
            pexc_ack_o = 1;

            @(posedge clk);
            #2;

            $display("Testcase 002: Exception Memory Read Access");
            #1;

            check_outputs(1'b1, 32'h55AA_CC33, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            pmem_adr_o = 32'h0000_2000;
            pmem_cyc_o = 1;
            pmem_stb_o = 1;
            pmain_stall_o = 1;

            @(posedge clk);
            #2;

            $display("Testcase 003: Main Memory Stall Propagation");
            #1;

            check_outputs(1'b0, 32'h0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            pmem_adr_o = 32'hF000_0000;
            pmem_cyc_o = 1;
            pmem_stb_o = 1;
            pexc_stall_o = 1;

            @(posedge clk);
            #2;

            $display("Testcase 004: Exception Memory Stall Propagation");
            #1;

            check_outputs(1'b0, 32'h0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            pmem_adr_o = 32'hFFFF_0000;
            pmem_cyc_o = 1;
            pmem_stb_o = 1;


            pexc_dat_o = 32'h1111_1111;
            pexc_ack_o = 1;

            pmain_dat_o = 32'hEEEE_EEEE;
            pmain_ack_o = 1;

            @(posedge clk);
            #2;

            $display("Testcase 005: Source Isolation (Exception Selected)");

            #1;


            check_outputs(1'b1, 32'h1111_1111, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            pmem_cyc_o = 0;
            pmem_stb_o = 0;
            pmain_ack_o = 1;
            pexc_ack_o = 1;

            @(posedge clk);
            #2;

            $display("Testcase 006: Idle State Check");
            #1;

            check_outputs(1'b0, 32'h0, 1'b0);
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
        input expected_pmem_ack_i;
        input [31:0] expected_pmem_dat_i;
        input expected_pmem_stall_i;
        begin
            if (expected_pmem_ack_i === (expected_pmem_ack_i ^ pmem_ack_i ^ expected_pmem_ack_i) &&
                expected_pmem_dat_i === (expected_pmem_dat_i ^ pmem_dat_i ^ expected_pmem_dat_i) &&
                expected_pmem_stall_i === (expected_pmem_stall_i ^ pmem_stall_i ^ expected_pmem_stall_i)) begin
                $display("PASS");
                $display("  Outputs: pmem_ack_i=%b, pmem_dat_i=%h, pmem_stall_i=%b",
                         pmem_ack_i, pmem_dat_i, pmem_stall_i);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pmem_ack_i=%b, pmem_dat_i=%h, pmem_stall_i=%b",
                         expected_pmem_ack_i, expected_pmem_dat_i, expected_pmem_stall_i);
                $display("  Got:      pmem_ack_i=%b, pmem_dat_i=%h, pmem_stall_i=%b",
                         pmem_ack_i, pmem_dat_i, pmem_stall_i);
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
        $dumpvars(0,clk, pexc_ack_o, pexc_dat_o, pexc_stall_o, pmain_ack_o, pmain_dat_o, pmain_stall_o, pmem_adr_o, pmem_cyc_o, pmem_stb_o, rst, pmem_ack_i, pmem_dat_i, pmem_stall_i);
    end

endmodule
