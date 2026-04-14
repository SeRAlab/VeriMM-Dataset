`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [7:0] difference;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .difference(difference)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple subtraction (A > B)", test_num);
            A = 8'd25;
            B = 8'd10;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Result is zero (A = B)", test_num);
            A = 8'd100;
            B = 8'd100;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Underflow / Negative result (A < B)", test_num);
            A = 8'd10;
            B = 8'd20;

            #1;


            check_outputs(8'd246);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum values", test_num);
            A = 8'hFF;
            B = 8'h00;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum minus Maximum", test_num);
            A = 8'h00;
            B = 8'hFF;

            #1;


            check_outputs(8'h01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits", test_num);
            A = 8'hAA;
            B = 8'h55;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtracting 1 from zero", test_num);
            A = 8'h00;
            B = 8'h01;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum minus one", test_num);
            A = 8'hFF;
            B = 8'h01;
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large difference", test_num);
            A = 8'd200;
            B = 8'd50;
            #1;

            check_outputs(8'd150);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary wrap-around check", test_num);
            A = 8'h80;
            B = 8'h81;
            #1;

            check_outputs(8'hFF);
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
        input [7:0] expected_difference;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_difference === (expected_difference ^ difference ^ expected_difference)) begin
                $display("PASS");
                $display("  Outputs: difference=%h",
                         difference);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: difference=%h",
                         expected_difference);
                $display("  Got:      difference=%h",
                         difference);
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
