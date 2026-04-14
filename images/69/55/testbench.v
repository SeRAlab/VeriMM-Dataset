`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [1:0] op;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .op(op),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (Positive + Positive)", test_num);
            a = 8'd50; b = 8'd75; op = 2'b00;
            #1;

            check_outputs(16'd125);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (Negative + Negative)", test_num);
            a = -8'd64; b = -8'd64; op = 2'b00;
            #1;

            check_outputs(-16'd128);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (Max values)", test_num);
            a = 8'd127; b = 8'd127; op = 2'b00;
            #1;

            check_outputs(16'd254);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (Positive - Positive)", test_num);
            a = 8'd100; b = 8'd40; op = 2'b01;
            #1;

            check_outputs(16'd60);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (Resulting in Negative)", test_num);
            a = 8'd10; b = 8'd50; op = 2'b01;
            #1;

            check_outputs(-16'd40);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (Min - Max)", test_num);
            a = -8'd128; b = 8'd127; op = 2'b01;
            #1;

            check_outputs(-16'd255);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication (Positive * Negative)", test_num);
            a = 8'd10; b = -8'd5; op = 2'b10;
            #1;

            check_outputs(-16'd50);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication (Large Values)", test_num);
            a = 8'd120; b = 8'd100; op = 2'b10;
            #1;

            check_outputs(16'd12000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication (Min * Min)", test_num);
            a = -8'd128; b = -8'd128; op = 2'b10;
            #1;

            check_outputs(16'd16384);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Division (Even)", test_num);
            a = 8'd100; b = 8'd4; op = 2'b11;
            #1;

            check_outputs(16'd25);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Division (Truncating)", test_num);
            a = -8'd7; b = 8'd2; op = 2'b11;
            #1;

            check_outputs(-16'd3);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Division (Zero Numerator)", test_num);
            a = 8'd0; b = 8'd10; op = 2'b11;
            #1;

            check_outputs(16'd0);
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
        input [15:0] expected_result;
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
