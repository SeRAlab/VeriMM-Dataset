`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a0;
    reg [31:0] a1;
    reg [31:0] a2;
    reg [5:0] sel_addr;
    wire [31:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a0(a0),
        .a1(a1),
        .a2(a2),
        .sel_addr(sel_addr),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Select a0 (Address 6'b110000)");
            a0 = 32'hDEADBEEF;
            a1 = 32'hCAFEBABE;
            a2 = 32'h12345678;
            sel_addr = 6'b110000;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Select a1 (Address 6'b110001)");
            a0 = 32'h00000001;
            a1 = 32'hFFFFFFFF;
            a2 = 32'h00000000;
            sel_addr = 6'b110001;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Select a2 (Address 6'b110010)");
            a0 = 32'hAAAA_AAAA;
            a1 = 32'hBBBB_BBBB;
            a2 = 32'hCCCC_CCCC;
            sel_addr = 6'b110010;
            #1;

            check_outputs(32'hCCCC_CCCC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Invalid Address (Address 6'b000000)");
            a0 = 32'h12345678;
            a1 = 32'h87654321;
            a2 = 32'hABCDEF01;
            sel_addr = 6'b000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Invalid Address Neighbor (Address 6'b110011)");
            a0 = 32'hFFFF_FFFF;
            a1 = 32'hFFFF_FFFF;
            a2 = 32'hFFFF_FFFF;
            sel_addr = 6'b110011;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Data Transparency for a1 with Zero");
            a0 = 32'hFFFF_FFFF;
            a1 = 32'h0000_0000;
            a2 = 32'hFFFF_FFFF;
            sel_addr = 6'b110001;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: All inputs set, check address 6'b111111");
            a0 = 32'h5555_5555;
            a1 = 32'hAAAA_AAAA;
            a2 = 32'h3333_3333;
            sel_addr = 6'b111111;
            #1;

            check_outputs(32'h0000_0000);
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
        input [31:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
