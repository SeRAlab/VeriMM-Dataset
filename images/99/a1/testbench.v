`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] Rd;
    reg [1:0] RegDst;
    reg [4:0] Rt;
    wire [4:0] writereg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Rd(Rd),
        .RegDst(RegDst),
        .Rt(Rt),
        .writereg(writereg)
    );
    task testcase001;

        begin
            $display("Test Case 001: RegDst = 00, should output Rd");
            RegDst = 2'b00;
            Rd = 5'd10;
            Rt = 5'd20;
            #1;

            check_outputs(5'd10);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: RegDst = 01, should output Rt");
            RegDst = 2'b01;
            Rd = 5'd10;
            Rt = 5'd20;
            #1;

            check_outputs(5'd20);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: RegDst = 10, should output constant 11111 (31)");
            RegDst = 2'b10;
            Rd = 5'd0;
            Rt = 5'd0;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: RegDst = 11, should output constant 11010 (26)");
            RegDst = 2'b11;
            Rd = 5'd5;
            Rt = 5'd5;
            #1;

            check_outputs(5'b11010);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: RegDst = 00, changing Rd value");
            RegDst = 2'b00;
            Rd = 5'd31;
            Rt = 5'd15;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: RegDst = 01, changing Rt value");
            RegDst = 2'b01;
            Rd = 5'd31;
            Rt = 5'd15;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: RegDst = 10, Rd/Rt values should not affect output");
            RegDst = 2'b10;
            Rd = 5'd25;
            Rt = 5'd12;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: RegDst = 11, Rd/Rt values should not affect output");
            RegDst = 2'b11;
            Rd = 5'd0;
            Rt = 5'd31;
            #1;

            check_outputs(5'b11010);
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
        input [4:0] expected_writereg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_writereg === (expected_writereg ^ writereg ^ expected_writereg)) begin
                $display("PASS");
                $display("  Outputs: writereg=%h",
                         writereg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: writereg=%h",
                         expected_writereg);
                $display("  Got:      writereg=%h",
                         writereg);
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
