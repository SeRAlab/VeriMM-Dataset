`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] port0_rd_addr;
    reg port0_rd_en;
    reg [9:0] port1_rd_addr;
    reg port1_rd_en;
    reg [8191:0] rd_data;
    wire [8191:0] port_rd_data;
    wire [9:0] rd_addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .port0_rd_addr(port0_rd_addr),
        .port0_rd_en(port0_rd_en),
        .port1_rd_addr(port1_rd_addr),
        .port1_rd_en(port1_rd_en),
        .rd_data(rd_data),
        .port_rd_data(port_rd_data),
        .rd_addr(rd_addr)
    );
    task testcase001;

        begin
            $display("Testcase 001: Port 0 Read Enable");
            test_num = 1;
            port0_rd_en = 1;
            port1_rd_en = 0;
            port0_rd_addr = 10'h1A2;
            port1_rd_addr = 10'h000;
            rd_data = {256{32'hAAAA_5555}};
            #1;

            check_outputs({256{32'hAAAA_5555}}, 10'h1A2);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Port 1 Read Enable");
            test_num = 2;
            port0_rd_en = 0;
            port1_rd_en = 1;
            port0_rd_addr = 10'h000;
            port1_rd_addr = 10'h2B3;
            rd_data = {256{32'hCCCC_3333}};
            #1;

            check_outputs({256{32'hCCCC_3333}}, 10'h2B3);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Port 0 at Max Address");
            test_num = 3;
            port0_rd_en = 1;
            port1_rd_en = 0;
            port0_rd_addr = 10'h3FF;
            port1_rd_addr = 10'h111;
            rd_data = {512{16'hFFFF}};
            #1;

            check_outputs({512{16'hFFFF}}, 10'h3FF);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Port 1 at Min Address and Zero Data");
            test_num = 4;
            port0_rd_en = 0;
            port1_rd_en = 1;
            port0_rd_addr = 10'h222;
            port1_rd_addr = 10'h000;
            rd_data = 8192'b0;
            #1;

            check_outputs(8192'b0, 10'h000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Verifying Data Pass-Through with Random-like Pattern");
            test_num = 5;
            port0_rd_en = 1;
            port1_rd_en = 0;
            port0_rd_addr = 10'h055;
            rd_data = {128{64'hFEDCBA9876543210}};
            #1;

            check_outputs({128{64'hFEDCBA9876543210}}, 10'h055);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Port 1 Priority Check or Selection Transition");
            test_num = 6;

            port0_rd_en = 0;
            port1_rd_en = 1;
            port1_rd_addr = 10'h123;
            rd_data = {256{32'h01234567}};
            #5;

            #1;


            check_outputs({256{32'h01234567}}, 10'h123);
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
        input [8191:0] expected_port_rd_data;
        input [9:0] expected_rd_addr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_port_rd_data === (expected_port_rd_data ^ port_rd_data ^ expected_port_rd_data) &&
                expected_rd_addr === (expected_rd_addr ^ rd_addr ^ expected_rd_addr)) begin
                $display("PASS");
                $display("  Outputs: port_rd_data=%h, rd_addr=%h",
                         port_rd_data, rd_addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: port_rd_data=%h, rd_addr=%h",
                         expected_port_rd_data, expected_rd_addr);
                $display("  Got:      port_rd_data=%h, rd_addr=%h",
                         port_rd_data, rd_addr);
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
