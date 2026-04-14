`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] RegDst;
    reg [4:0] rd;
    reg [4:0] rt;
    wire [4:0] WriteReg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RegDst(RegDst),
        .rd(rd),
        .rt(rt),
        .WriteReg(WriteReg)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: RegDst = 00 (Expect WriteReg = 31)");
            RegDst = 2'b00;
            rt = 5'h0A;
            rd = 5'h15;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: RegDst = 01 (Expect WriteReg = rt)");
            RegDst = 2'b01;
            rt = 5'h12;
            rd = 5'h05;
            #1;

            check_outputs(5'h12);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: RegDst = 10 (Expect WriteReg = rd)");
            RegDst = 2'b10;
            rt = 5'h12;
            rd = 5'h05;
            #1;

            check_outputs(5'h05);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: State Retention (00 -> 11)");

            RegDst = 2'b00;
            #5;

            RegDst = 2'b11;
            rt = 5'h00;
            rd = 5'h00;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: State Retention (01 -> 11)");

            RegDst = 2'b01;
            rt = 5'h1A;
            #5;

            RegDst = 2'b11;
            rt = 5'h00;
            #1;

            check_outputs(5'h1A);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: State Retention (10 -> 11)");

            RegDst = 2'b10;
            rd = 5'h0F;
            #5;

            RegDst = 2'b11;
            rd = 5'h1F;
            #1;

            check_outputs(5'h0F);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Multiple inputs change while RegDst = 11");

            RegDst = 2'b01;
            rt = 5'h08;
            #5;

            RegDst = 2'b11;
            #5;

            rt = 5'h11;
            rd = 5'h12;
            #5;
            #1;

            check_outputs(5'h08);
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
        input [4:0] expected_WriteReg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_WriteReg === (expected_WriteReg ^ WriteReg ^ expected_WriteReg)) begin
                $display("PASS");
                $display("  Outputs: WriteReg=%h",
                         WriteReg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: WriteReg=%h",
                         expected_WriteReg);
                $display("  Got:      WriteReg=%h",
                         WriteReg);
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
