`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg carryIn;
    reg [3:0] operand1;
    reg [3:0] operand2;
    wire carryOut;
    wire g;
    wire p;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .carryIn(carryIn),
        .operand1(operand1),
        .operand2(operand2),
        .carryOut(carryOut),
        .g(g),
        .p(p),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            operand1 = 4'b0000;
            operand2 = 4'b0000;
            carryIn = 1'b0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition without carry", test_num);
            operand1 = 4'b0101;
            operand2 = 4'b0010;
            carryIn = 1'b0;




            #1;





            check_outputs(1'b0, 1'b0, 1'b0, 4'b0111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Propagate carry from cin", test_num);
            operand1 = 4'b1111;
            operand2 = 4'b0000;
            carryIn = 1'b1;






            #1;







            check_outputs(1'b1, 1'b0, 1'b1, 4'b0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Generate carry from LSB (g block check)", test_num);
            operand1 = 4'b1111;
            operand2 = 4'b0001;
            carryIn = 1'b0;





            #1;






            check_outputs(1'b1, 1'b1, 1'b0, 4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Full Propagate path", test_num);
            operand1 = 4'b1010;
            operand2 = 4'b0101;
            carryIn = 1'b1;




            #1;





            check_outputs(1'b1, 1'b0, 1'b1, 4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max values with carryIn", test_num);
            operand1 = 4'b1111;
            operand2 = 4'b1111;
            carryIn = 1'b1;



            #1;




            check_outputs(1'b1, 1'b1, 1'b0, 4'b1111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB Generate", test_num);
            operand1 = 4'b1000;
            operand2 = 4'b1000;
            carryIn = 1'b0;



            #1;




            check_outputs(1'b1, 1'b1, 1'b0, 4'b0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed bits", test_num);
            operand1 = 4'b1100;
            operand2 = 4'b0110;
            carryIn = 1'b1;




            #1;





            check_outputs(1'b1, 1'b1, 1'b0, 4'b0011);
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
        input expected_carryOut;
        input expected_g;
        input expected_p;
        input [3:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carryOut === (expected_carryOut ^ carryOut ^ expected_carryOut) &&
                expected_g === (expected_g ^ g ^ expected_g) &&
                expected_p === (expected_p ^ p ^ expected_p) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: carryOut=%b, g=%b, p=%b, result=%h",
                         carryOut, g, p, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carryOut=%b, g=%b, p=%b, result=%h",
                         expected_carryOut, expected_g, expected_p, expected_result);
                $display("  Got:      carryOut=%b, g=%b, p=%b, result=%h",
                         carryOut, g, p, result);
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
