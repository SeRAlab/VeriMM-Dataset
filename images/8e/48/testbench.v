`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] D;
    wire [1:0] Y;
    wire _IN_ERR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .Y(Y),
        ._IN_ERR(_IN_ERR)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input D=4'b0001 (Valid index 0)", test_num);
            D = 4'b0001;
            #1;

            check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input D=4'b0010 (Valid index 1)", test_num);
            D = 4'b0010;
            #1;

            check_outputs(2'b01, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input D=4'b0100 (Valid index 2)", test_num);
            D = 4'b0100;
            #1;

            check_outputs(2'b10, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input D=4'b1000 (Valid index 3)", test_num);
            D = 4'b1000;
            #1;

            check_outputs(2'b11, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input D=4'b0000 (Error: No active inputs)", test_num);
            D = 4'b0000;

            #1;


            check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input D=4'b0011 (Error: Multiple inputs high)", test_num);
            D = 4'b0011;

            #1;


            check_outputs(2'b01, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input D=4'b1100 (Error: Multiple inputs high)", test_num);
            D = 4'b1100;

            #1;


            check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input D=4'b1010 (Error: Multiple inputs high)", test_num);
            D = 4'b1010;

            #1;


            check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input D=4'b0111 (Error: Multiple inputs high)", test_num);
            D = 4'b0111;

            #1;


            check_outputs(2'b10, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input D=4'b1111 (Error: All inputs high)", test_num);
            D = 4'b1111;

            #1;


            check_outputs(2'b11, 1'b1);
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
        input [1:0] expected_Y;
        input expected__IN_ERR;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y) &&
                expected__IN_ERR === (expected__IN_ERR ^ _IN_ERR ^ expected__IN_ERR)) begin
                $display("PASS");
                $display("  Outputs: Y=%h, _IN_ERR=%b",
                         Y, _IN_ERR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h, _IN_ERR=%b",
                         expected_Y, expected__IN_ERR);
                $display("  Got:      Y=%h, _IN_ERR=%b",
                         Y, _IN_ERR);
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
