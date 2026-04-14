`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] ctl;
    reg in;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctl(ctl),
        .in(in),
        .out(out)
    );
    task testcase001;

    begin
        $display("Running Testcase 001: Input 0, Control 0");
        test_num = 1;
        ctl = 3'b000;
        in = 1'b0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        $display("Running Testcase 002: Input 1, Control 000 (Target out[0])");
        test_num = 2;
        ctl = 3'b000;
        in = 1'b1;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase003;

    begin
        $display("Running Testcase 003: Input 1, Control 001 (Target out[1])");
        test_num = 3;
        ctl = 3'b001;
        in = 1'b1;
        #1;

        check_outputs(8'h02);
    end
        endtask

    task testcase004;

    begin
        $display("Running Testcase 004: Input 1, Control 010 (Target out[2])");
        test_num = 4;
        ctl = 3'b010;
        in = 1'b1;
        #1;

        check_outputs(8'h04);
    end
        endtask

    task testcase005;

    begin
        $display("Running Testcase 005: Input 1, Control 011 (Target out[3])");
        test_num = 5;
        ctl = 3'b011;
        in = 1'b1;
        #1;

        check_outputs(8'h08);
    end
        endtask

    task testcase006;

    begin
        $display("Running Testcase 006: Input 1, Control 100 (Target out[4])");
        test_num = 6;
        ctl = 3'b100;
        in = 1'b1;
        #1;

        check_outputs(8'h10);
    end
        endtask

    task testcase007;

    begin
        $display("Running Testcase 007: Input 1, Control 101 (Target out[5])");
        test_num = 7;
        ctl = 3'b101;
        in = 1'b1;
        #1;

        check_outputs(8'h20);
    end
        endtask

    task testcase008;

    begin
        $display("Running Testcase 008: Input 1, Control 110 (Target out[6])");
        test_num = 8;
        ctl = 3'b110;
        in = 1'b1;
        #1;

        check_outputs(8'h40);
    end
        endtask

    task testcase009;

    begin
        $display("Running Testcase 009: Input 1, Control 111 (Target out[7])");
        test_num = 9;
        ctl = 3'b111;
        in = 1'b1;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase010;

    begin
        $display("Running Testcase 010: Input 0, Control 111 (Should be all 0)");
        test_num = 10;
        ctl = 3'b111;
        in = 1'b0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase011;

    begin
        $display("Running Testcase 011: Verify non-selected outputs remain LOW");
        test_num = 11;
        ctl = 3'b010;
        in = 1'b1;

        #1;


        check_outputs(8'b0000_0100);
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
        testcase009();
        testcase010();
        testcase011();
        
        
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
        input [7:0] expected_out;
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
