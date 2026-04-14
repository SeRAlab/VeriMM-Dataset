`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] Br_type;
    reg [31:0] Src2_Val;
    reg [31:0] val1;
    wire Br_taken;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Br_type(Br_type),
        .Src2_Val(Src2_Val),
        .val1(val1),
        .Br_taken(Br_taken)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Br_type=00 (Always LOW)");
            Br_type = 2'b00;
            val1 = 32'hFFFF_FFFF;
            Src2_Val = 32'hFFFF_FFFF;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Br_type=01, val1=0 (Branch if Zero - Taken)");
            Br_type = 2'b01;
            val1 = 32'h0000_0000;
            Src2_Val = 32'h1234_5678;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Br_type=01, val1!=0 (Branch if Zero - Not Taken)");
            Br_type = 2'b01;
            val1 = 32'h0000_0001;
            Src2_Val = 32'h0000_0000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Br_type=10, val1 != Src2_Val (Branch if Not Equal - Taken)");
            Br_type = 2'b10;
            val1 = 32'hAAAA_AAAA;
            Src2_Val = 32'hBBBB_BBBB;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Br_type=10, val1 == Src2_Val (Branch if Not Equal - Not Taken)");
            Br_type = 2'b10;
            val1 = 32'h1234_5678;
            Src2_Val = 32'h1234_5678;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Br_type=11 (Always HIGH)");
            Br_type = 2'b11;
            val1 = 32'h0;
            Src2_Val = 32'h0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Br_type=01, val1 with large value");
            Br_type = 2'b01;
            val1 = 32'h8000_0000;
            Src2_Val = 32'h0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: Br_type=11, random inputs");
            Br_type = 2'b11;
            val1 = 32'hDEAD_BEEF;
            Src2_Val = 32'hCAFE_BABE;
            #1;

            check_outputs(1'b1);
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
        input expected_Br_taken;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Br_taken === (expected_Br_taken ^ Br_taken ^ expected_Br_taken)) begin
                $display("PASS");
                $display("  Outputs: Br_taken=%b",
                         Br_taken);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Br_taken=%b",
                         expected_Br_taken);
                $display("  Got:      Br_taken=%b",
                         Br_taken);
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
