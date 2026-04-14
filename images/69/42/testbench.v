`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg probe0;
    reg [7:0] probe1;
    reg probe2;
    reg [7:0] probe3;
    wire out_probe0;
    wire [7:0] out_probe1;
    wire out_probe2;
    wire [7:0] out_probe3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .probe0(probe0),
        .probe1(probe1),
        .probe2(probe2),
        .probe3(probe3),
        .out_probe0(out_probe0),
        .out_probe1(out_probe1),
        .out_probe2(out_probe2),
        .out_probe3(out_probe3)
    );
    task testcase001;

        begin
            $display("Testcase 001: All zeros input");
            probe0 = 1'b0;
            probe1 = 8'h00;
            probe2 = 1'b0;
            probe3 = 8'h00;
            #10;

            #1;


            check_outputs(1'b0, 8'hFF, 1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: All ones input");
            probe0 = 1'b1;
            probe1 = 8'hFF;
            probe2 = 1'b1;
            probe3 = 8'hFF;
            #10;

            #1;


            check_outputs(1'b1, 8'h00, 1'b1, 8'h55);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Pattern 0xAA");
            probe0 = 1'b0;
            probe1 = 8'hAA;
            probe2 = 1'b1;
            probe3 = 8'hAA;
            #10;

            #1;


            check_outputs(1'b0, 8'h55, 1'b1, 8'h00);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Pattern 0x55");
            probe0 = 1'b1;
            probe1 = 8'h55;
            probe2 = 1'b0;
            probe3 = 8'h55;
            #10;

            #1;


            check_outputs(1'b1, 8'hAA, 1'b0, 8'h55);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Arbitrary pattern 0x12, 0x34");
            probe0 = 1'b0;
            probe1 = 8'h12;
            probe2 = 1'b0;
            probe3 = 8'h34;
            #10;

            #1;


            check_outputs(1'b0, 8'hED, 1'b0, 8'h14);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Arbitrary pattern 0xBE, 0xEF");
            probe0 = 1'b1;
            probe1 = 8'hBE;
            probe2 = 1'b1;
            probe3 = 8'hEF;
            #10;

            #1;


            check_outputs(1'b1, 8'h41, 1'b1, 8'h45);
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
        input expected_out_probe0;
        input [7:0] expected_out_probe1;
        input expected_out_probe2;
        input [7:0] expected_out_probe3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_probe0 === (expected_out_probe0 ^ out_probe0 ^ expected_out_probe0) &&
                expected_out_probe1 === (expected_out_probe1 ^ out_probe1 ^ expected_out_probe1) &&
                expected_out_probe2 === (expected_out_probe2 ^ out_probe2 ^ expected_out_probe2) &&
                expected_out_probe3 === (expected_out_probe3 ^ out_probe3 ^ expected_out_probe3)) begin
                $display("PASS");
                $display("  Outputs: out_probe0=%b, out_probe1=%h, out_probe2=%b, out_probe3=%h",
                         out_probe0, out_probe1, out_probe2, out_probe3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_probe0=%b, out_probe1=%h, out_probe2=%b, out_probe3=%h",
                         expected_out_probe0, expected_out_probe1, expected_out_probe2, expected_out_probe3);
                $display("  Got:      out_probe0=%b, out_probe1=%h, out_probe2=%b, out_probe3=%h",
                         out_probe0, out_probe1, out_probe2, out_probe3);
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
