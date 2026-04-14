`timescale 1ns/1ps

module adder_subtractor_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg subtract;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_subtractor dut (
        .A(A),
        .B(B),
        .subtract(subtract),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 4'd5;
            B = 4'd3;
            subtract = 1'b0;
            $display("Testcase %0d: Addition 5 + 3", test_num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 4'd10;
            B = 4'd4;
            subtract = 1'b1;
            $display("Testcase %0d: Subtraction 10 - 4", test_num);
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 4'd12;
            B = 4'd5;
            subtract = 1'b0;
            $display("Testcase %0d: Addition Overflow 12 + 5 (mod 16)", test_num);
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 4'd2;
            B = 4'd5;
            subtract = 1'b1;
            $display("Testcase %0d: Subtraction Underflow 2 - 5 (mod 16)", test_num);
            #1;

            check_outputs(4'd13);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 4'd0;
            B = 4'd0;
            subtract = 1'b0;
            $display("Testcase %0d: Addition Zeroes 0 + 0", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 4'd15;
            B = 4'd15;
            subtract = 1'b0;
            $display("Testcase %0d: Max values addition 15 + 15 (mod 16)", test_num);
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 4'd15;
            B = 4'd15;
            subtract = 1'b1;
            $display("Testcase %0d: Max values subtraction 15 - 15", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 4'd0;
            B = 4'd1;
            subtract = 1'b1;
            $display("Testcase %0d: Subtraction 0 - 1 (mod 16)", test_num);
            #1;

            check_outputs(4'd15);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_subtractor Testbench");
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
        input [3:0] expected_result;
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
