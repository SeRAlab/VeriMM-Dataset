`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg op1sel;
    reg [31:0] rs1;
    reg [19:0] upperimm;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .op1sel(op1sel),
        .rs1(rs1),
        .upperimm(upperimm),
        .out(out)
    );
    task testcase001;

        begin
            $display("Testcase 001: Select rs1 - All Zeros");
            test_num = 1;
            op1sel = 1'b0;
            rs1 = 32'h0000_0000;
            upperimm = 20'hFFFFF;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Select rs1 - All Ones");
            test_num = 2;
            op1sel = 1'b0;
            rs1 = 32'hFFFF_FFFF;
            upperimm = 20'h00000;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Select rs1 - Random Pattern");
            test_num = 3;
            op1sel = 1'b0;
            rs1 = 32'hA5A5_B6B6;
            upperimm = 20'h12345;
            #1;

            check_outputs(32'hA5A5_B6B6);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Select upperimm - All Zeros");
            test_num = 4;
            op1sel = 1'b1;
            rs1 = 32'hFFFF_FFFF;
            upperimm = 20'h00000;

            #1;


            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Select upperimm - All Ones");
            test_num = 5;
            op1sel = 1'b1;
            rs1 = 32'h0000_0000;
            upperimm = 20'hFFFFF;
            #1;

            check_outputs(32'hFFFF_F000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Select upperimm - Mixed Pattern");
            test_num = 6;
            op1sel = 1'b1;
            rs1 = 32'h1234_5678;
            upperimm = 20'hABCDE;
            #1;

            check_outputs(32'hABCD_E000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Rapid Toggle Check");
            test_num = 7;
            rs1 = 32'h8765_4321;
            upperimm = 20'h54321;


            op1sel = 1'b0;
            #1;


            op1sel = 1'b1;
            #1;

            check_outputs(32'h5432_1000);
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
