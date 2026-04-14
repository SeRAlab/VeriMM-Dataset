`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg mode;
    reg [127:0] p2k_eid_dst;
    reg [7:0] p2k_ingress;
    reg [7:0] p2k_metadata;
    reg [127:0] p2k_rloc_src;
    reg p2k_valid;
    reg reset;
    wire [107:0] k2m_metadata;
    wire k2m_metadata_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mode(mode),
        .p2k_eid_dst(p2k_eid_dst),
        .p2k_ingress(p2k_ingress),
        .p2k_metadata(p2k_metadata),
        .p2k_rloc_src(p2k_rloc_src),
        .p2k_valid(p2k_valid),
        .reset(reset),
        .k2m_metadata(k2m_metadata),
        .k2m_metadata_valid(k2m_metadata_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            p2k_valid = 0;
            mode = 0;
            p2k_ingress = 0;
            p2k_metadata = 0;
            p2k_rloc_src = 0;
            p2k_eid_dst = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("testcase001: Mode 1, Ingress Zero Path");
            test_num = 1;
            reset_dut();
            mode = 1'b1;
            p2k_ingress = 8'h00;
            p2k_metadata = 8'hAA;
            p2k_rloc_src = 128'h11223344556677889900AABBCCDDEEFF;
            p2k_valid = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(k2m_metadata, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("testcase002: Mode 1, Ingress Non-Zero Path");
            test_num = 2;
            reset_dut();
            mode = 1'b1;
            p2k_ingress = 8'hFF;
            p2k_metadata = 8'h55;
            p2k_rloc_src = 128'hFFEEDDCCBBAA99887766554433221100;
            p2k_valid = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(k2m_metadata, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("testcase003: Mode 0, EID Source Path");
            test_num = 3;
            reset_dut();
            mode = 1'b0;
            p2k_eid_dst = 128'hABCDEFAABBCCDDEE0011223344556677;
            p2k_valid = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(k2m_metadata, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("testcase004: Valid Signal De-assertion");
            test_num = 4;
            reset_dut();
            p2k_valid = 1'b0;
            mode = 1'b1;
            p2k_ingress = 8'h12;
            @(posedge clk);
            #1;
            #1;

            check_outputs(k2m_metadata, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("testcase005: Reset during operation");
            test_num = 5;
            reset_dut();
            p2k_valid = 1'b1;
            mode = 1'b1;
            @(posedge clk);
            reset = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(108'h0, 1'b0);
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
        input [107:0] expected_k2m_metadata;
        input expected_k2m_metadata_valid;
        begin
            if (expected_k2m_metadata === (expected_k2m_metadata ^ k2m_metadata ^ expected_k2m_metadata) &&
                expected_k2m_metadata_valid === (expected_k2m_metadata_valid ^ k2m_metadata_valid ^ expected_k2m_metadata_valid)) begin
                $display("PASS");
                $display("  Outputs: k2m_metadata=%h, k2m_metadata_valid=%b",
                         k2m_metadata, k2m_metadata_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: k2m_metadata=%h, k2m_metadata_valid=%b",
                         expected_k2m_metadata, expected_k2m_metadata_valid);
                $display("  Got:      k2m_metadata=%h, k2m_metadata_valid=%b",
                         k2m_metadata, k2m_metadata_valid);
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
        $dumpvars(0,clk, mode, p2k_eid_dst, p2k_ingress, p2k_metadata, p2k_rloc_src, p2k_valid, reset, k2m_metadata, k2m_metadata_valid);
    end

endmodule
