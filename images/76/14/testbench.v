`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] c;
    reg [3:0] in0;
    reg [3:0] in1;
    wire [3:0] alu_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c(c),
        .in0(in0),
        .in1(in1),
        .alu_out(alu_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            c = 2'b00; in0 = 4'd5; in1 = 4'd3;
            $display("Test %0d: Addition (5 + 3)", test_num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            c = 2'b00; in0 = 4'd12; in1 = 4'd7;
            $display("Test %0d: Addition with Overflow (12 + 7 = 19 -> 3)", test_num);
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            c = 2'b01; in0 = 4'd10; in1 = 4'd4;
            $display("Test %0d: Subtraction (10 - 4)", test_num);
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            c = 2'b01; in0 = 4'd2; in1 = 4'd5;
            $display("Test %0d: Subtraction with Borrow (2 - 5 = -3 -> 13)", test_num);
            #1;

            check_outputs(4'd13);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            c = 2'b10; in0 = 4'b1100; in1 = 4'b1010;
            $display("Test %0d: Bitwise AND (1100 & 1010)", test_num);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            c = 2'b10; in0 = 4'b1111; in1 = 4'b0000;
            $display("Test %0d: Bitwise AND (1111 & 0000)", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            c = 2'b11; in0 = 4'b1100; in1 = 4'b1010;
            $display("Test %0d: Bitwise XOR (1100 ^ 1010)", test_num);
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            c = 2'b11; in0 = 4'b1111; in1 = 4'b1111;
            $display("Test %0d: Bitwise XOR (1111 ^ 1111)", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            c = 2'b11; in0 = 4'b0101; in1 = 4'b1010;
            $display("Test %0d: Bitwise XOR (0101 ^ 1010)", test_num);
            #1;

            check_outputs(4'b1111);
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
        input [3:0] expected_alu_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_alu_out === (expected_alu_out ^ alu_out ^ expected_alu_out)) begin
                $display("PASS");
                $display("  Outputs: alu_out=%h",
                         alu_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alu_out=%h",
                         expected_alu_out);
                $display("  Got:      alu_out=%h",
                         alu_out);
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
