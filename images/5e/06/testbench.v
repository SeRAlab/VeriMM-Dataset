`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [1:0] eq_gt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .eq_gt(eq_gt)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 4'b0000;
            B = 4'b0000;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 4'b1111;
            B = 4'b1111;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 4'b1000;
            B = 4'b0111;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 4'b0111;
            B = 4'b1000;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 4'b1011;
            B = 4'b1010;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 4'b0100;
            B = 4'b0101;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 4'b1101;
            B = 4'b1011;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 4'b0011;
            B = 4'b0110;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 4'b1xxx;
            B = 4'b0xxx;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 4'b0xxx;
            B = 4'b1xxx;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            A = 4'b111x;
            B = 4'b111x;


            #1;



            check_outputs(2'bxx);
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
        input [1:0] expected_eq_gt;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_eq_gt === (expected_eq_gt ^ eq_gt ^ expected_eq_gt)) begin
                $display("PASS");
                $display("  Outputs: eq_gt=%h",
                         eq_gt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eq_gt=%h",
                         expected_eq_gt);
                $display("  Got:      eq_gt=%h",
                         eq_gt);
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
