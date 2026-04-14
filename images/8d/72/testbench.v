`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [1:0] MODE;
    reg SEL_ADD;
    wire OVERFLOW;
    wire [4:0] RESULT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .MODE(MODE),
        .SEL_ADD(SEL_ADD),
        .OVERFLOW(OVERFLOW),
        .RESULT(RESULT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 4'd5;
            B = 4'd3;
            SEL_ADD = 1'b1;
            MODE = 2'b00;
            $display("Test %0d: Simple Addition (5 + 3)", test_num);

            #1;


            check_outputs(1'b0, 5'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 4'd12;
            B = 4'd4;
            SEL_ADD = 1'b1;
            MODE = 2'b00;
            $display("Test %0d: Unsigned Carry Addition (12 + 4 = 16)", test_num);

            #1;


            check_outputs(1'b1, 5'd16);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 4'd10;
            B = 4'd4;
            SEL_ADD = 1'b0;
            MODE = 2'b00;
            $display("Test %0d: Simple Subtraction (10 - 4)", test_num);

            #1;


            check_outputs(1'b0, 5'd6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 4'd3;
            B = 4'd8;
            SEL_ADD = 1'b0;
            MODE = 2'b00;
            $display("Test %0d: Subtraction with negative result (3 - 8)", test_num);


            #1;



            check_outputs(1'b1, 5'd27);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 4'd7;
            B = 4'd1;
            SEL_ADD = 1'b1;
            MODE = 2'b01;
            $display("Test %0d: Signed Overflow Addition (7 + 1 = 8/Overflow)", test_num);

            #1;


            check_outputs(1'b1, 5'd8);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 4'd8;
            B = 4'd1;
            SEL_ADD = 1'b0;
            MODE = 2'b10;
            $display("Test %0d: Signed Overflow Subtraction (-8 - 1)", test_num);



            #1;




            check_outputs(1'b1, 5'd7);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 4'hf;
            B = 4'hf;
            SEL_ADD = 1'b1;
            MODE = 2'b11;
            $display("Test %0d: Maximum values addition (15 + 15)", test_num);
            #1;

            check_outputs(1'b1, 5'd30);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 4'd0;
            B = 4'd0;
            SEL_ADD = 1'b0;
            MODE = 2'b00;
            $display("Test %0d: Zero subtraction (0 - 0)", test_num);
            #1;

            check_outputs(1'b0, 5'd0);
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
        input expected_OVERFLOW;
        input [4:0] expected_RESULT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OVERFLOW === (expected_OVERFLOW ^ OVERFLOW ^ expected_OVERFLOW) &&
                expected_RESULT === (expected_RESULT ^ RESULT ^ expected_RESULT)) begin
                $display("PASS");
                $display("  Outputs: OVERFLOW=%b, RESULT=%h",
                         OVERFLOW, RESULT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OVERFLOW=%b, RESULT=%h",
                         expected_OVERFLOW, expected_RESULT);
                $display("  Got:      OVERFLOW=%b, RESULT=%h",
                         OVERFLOW, RESULT);
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
