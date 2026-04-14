`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg C;
    reg [3:0] D;
    wire eq;
    wire [3:0] final_output;
    wire gt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .eq(eq),
        .final_output(final_output),
        .gt(gt)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 4'd5; B = 4'd5; C = 1'b0; D = 4'd0;

            #1;


            check_outputs(1'b1, 4'b0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 4'd10; B = 4'd5; C = 1'b0; D = 4'd0;

            #1;


            check_outputs(1'b0, 4'b0000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 4'd3; B = 4'd8; C = 1'b0; D = 4'd0;

            #1;


            check_outputs(1'b0, 4'b0000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 4'b0011; B = 4'b0011; C = 1'b0; D = 4'd1;

            #1;


            check_outputs(1'b1, 4'b0000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 4'b0011; B = 4'b0001; C = 1'b0; D = 4'd2;

            #1;


            check_outputs(1'b0, 4'b0000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 4'b1100; B = 4'b1100; C = 1'b1; D = 4'd1;

            #1;


            check_outputs(1'b1, 4'b0000, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 4'b1100; B = 4'b1000; C = 1'b1; D = 4'd2;

            #1;


            check_outputs(1'b0, 4'b0000, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 4'b1111; B = 4'b1111; C = 1'b0; D = 4'd4;

            #1;


            check_outputs(1'b1, 4'b0000, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 4'b1111; B = 4'b0000; C = 1'b1; D = 4'd3;

            #1;


            check_outputs(1'b0, 4'b0000, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 4'b0000; B = 4'b0000; C = 1'b0; D = 4'd2;

            #1;


            check_outputs(1'b1, 4'b0000, 1'b0);
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
        input expected_eq;
        input [3:0] expected_final_output;
        input expected_gt;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_eq === (expected_eq ^ eq ^ expected_eq) &&
                expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_gt === (expected_gt ^ gt ^ expected_gt)) begin
                $display("PASS");
                $display("  Outputs: eq=%b, final_output=%h, gt=%b",
                         eq, final_output, gt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eq=%b, final_output=%h, gt=%b",
                         expected_eq, expected_final_output, expected_gt);
                $display("  Got:      eq=%b, final_output=%h, gt=%b",
                         eq, final_output, gt);
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
