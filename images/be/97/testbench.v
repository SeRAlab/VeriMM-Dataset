`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire [2:0] pos;

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
            in = 8'b00000000;
            $display("Test %0d: No bits set (Input: %b)", test_num, in);
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in = 8'b00000001;
            $display("Test %0d: Bit 0 set (Input: %b)", test_num, in);
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in = 8'b00000010;
            $display("Test %0d: Bit 1 set (Input: %b)", test_num, in);
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in = 8'b00001000;
            $display("Test %0d: Bit 3 set (Input: %b)", test_num, in);
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in = 8'b01000000;
            $display("Test %0d: Bit 6 set (Input: %b)", test_num, in);
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in = 8'b10000000;
            $display("Test %0d: Bit 7 set (Input: %b)", test_num, in);
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in = 8'b10000001;
            $display("Test %0d: Priority check - Bits 7 and 0 set (Input: %b)", test_num, in);
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in = 8'b00110011;
            $display("Test %0d: Priority check - Bit 5 is highest (Input: %b)", test_num, in);
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            in = 8'b00000111;
            $display("Test %0d: Priority check - Bit 2 is highest (Input: %b)", test_num, in);
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            in = 8'b11111111;
            $display("Test %0d: All bits set (Input: %b)", test_num, in);
            #1;

            check_outputs(3'b111);
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
        input [2:0] expected_pos;
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
