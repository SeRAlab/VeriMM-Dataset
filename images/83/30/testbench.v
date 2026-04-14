`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [10:0] addr;
    reg [7:0] btn;
    reg en;
    reg [31:0] ms;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .btn(btn),
        .en(en),
        .ms(ms),
        .out(out)
    );
    task testcase001;

        begin
            $display("Test Case 001: en=0, addr=1");
            en = 0;
            addr = 11'd1;
            btn = 8'hA5;
            ms = 32'h12345678;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: en=1, addr=1");
            en = 1;
            addr = 11'd1;
            btn = 8'hA5;
            ms = 32'h12345678;

            #1;


            check_outputs({8'hA5, 24'h000000});
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: en=1, addr=2");
            en = 1;
            addr = 11'd2;
            btn = 8'hFF;
            ms = 32'hDEADBEEF;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: en=1, addr=3");
            en = 1;
            addr = 11'd3;
            btn = 8'h55;
            ms = 32'hAAAA5555;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: en=0, addr=2");
            en = 0;
            addr = 11'd2;
            btn = 8'h00;
            ms = 32'h87654321;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: en=1, addr=0");
            en = 1;
            addr = 11'd0;
            btn = 8'h12;
            ms = 32'h0000FFFF;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: en=1, addr=2047");
            en = 1;
            addr = 11'h7FF;
            btn = 8'h99;
            ms = 32'hBCBCBCBC;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: en=1, addr=2 (Updated MS)");
            en = 1;
            addr = 11'd2;
            btn = 8'h00;
            ms = 32'h55AA55AA;
            #1;

            check_outputs(32'h55AA55AA);
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
        testcase008();
        
        
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
