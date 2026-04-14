`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [1:0] opcode;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .opcode(opcode),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (5 + 10)", test_num);
            a = 8'd5; b = 8'd10; opcode = 2'b00;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (-5 + -10)", test_num);
            a = -8'd5; b = -8'd10; opcode = 2'b00;
            #1;

            check_outputs(-8'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition overflow (127 + 1)", test_num);
            a = 8'sd127; b = 8'sd1; opcode = 2'b00;
            #1;

            check_outputs(-8'sd128);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (20 - 5)", test_num);
            a = 8'd20; b = 8'd5; opcode = 2'b01;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (5 - 20)", test_num);
            a = 8'd5; b = 8'd20; opcode = 2'b01;
            #1;

            check_outputs(-8'sd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction underflow (-128 - 1)", test_num);
            a = -8'sd128; b = 8'sd1; opcode = 2'b01;
            #1;

            check_outputs(8'sd127);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication (12 * 4)", test_num);
            a = 8'sd12; b = 8'sd4; opcode = 2'b10;
            #1;

            check_outputs(8'sd48);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication (-6 * 7)", test_num);
            a = -8'sd6; b = 8'sd7; opcode = 2'b10;
            #1;

            check_outputs(-8'sd42);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication wrap (20 * 10)", test_num);
            a = 8'sd20; b = 8'sd10; opcode = 2'b10;

            #1;


            check_outputs(-8'sd56);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division (40 / 8)", test_num);
            a = 8'sd40; b = 8'sd8; opcode = 2'b11;
            #1;

            check_outputs(8'sd5);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division (-30 / 5)", test_num);
            a = -8'sd30; b = 8'sd5; opcode = 2'b11;
            #1;

            check_outputs(-8'sd6);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division rounding (15 / 4)", test_num);
            a = 8'sd15; b = 8'sd4; opcode = 2'b11;
            #1;

            check_outputs(8'sd3);
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
        testcase012();
        
        
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
        input [7:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
