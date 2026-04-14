`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in;
    wire [1:0] pos;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .pos(pos)
    );
    task testcase001;

    begin
        test_num = 1;
        in = 4'b0000;
        $display("Test %0d: Input %b (No bits set, default)", test_num, in);
        #1;

        check_outputs(2'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in = 4'b0001;
        $display("Test %0d: Input %b (Bit 0 set)", test_num, in);
        #1;

        check_outputs(2'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in = 4'b0010;
        $display("Test %0d: Input %b (Bit 1 set)", test_num, in);
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in = 4'b0100;
        $display("Test %0d: Input %b (Bit 2 set)", test_num, in);
        #1;

        check_outputs(2'd2);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in = 4'b1000;
        $display("Test %0d: Input %b (Bit 3 set)", test_num, in);
        #1;

        check_outputs(2'd3);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in = 4'b0011;
        $display("Test %0d: Input %b (Bits 0 and 1 set)", test_num, in);
        #1;

        check_outputs(2'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in = 4'b0110;
        $display("Test %0d: Input %b (Bits 1 and 2 set)", test_num, in);
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in = 4'b1100;
        $display("Test %0d: Input %b (Bits 2 and 3 set)", test_num, in);
        #1;

        check_outputs(2'd2);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        in = 4'b1011;
        $display("Test %0d: Input %b (Multiple bits, LSB at 0)", test_num, in);
        #1;

        check_outputs(2'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        in = 4'b1010;
        $display("Test %0d: Input %b (Multiple bits, LSB at 1)", test_num, in);
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        in = 4'b1111;
        $display("Test %0d: Input %b (All bits set)", test_num, in);
        #1;

        check_outputs(2'd0);
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
        input [1:0] expected_pos;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pos === (expected_pos ^ pos ^ expected_pos)) begin
                $display("PASS");
                $display("  Outputs: pos=%h",
                         pos);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pos=%h",
                         expected_pos);
                $display("  Got:      pos=%h",
                         pos);
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
