`timescale 1ns/1ps

module FixedPointMultiplier_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [15:0] Result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    FixedPointMultiplier dut (
        .A(A),
        .B(B),
        .Result(Result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Multiplication (0.0 * 0.0)", test_num);
            A = 8'h00;
            B = 8'h00;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive Multiplication (0.5 * 0.5)", test_num);
            A = 8'h40;
            B = 8'h40;
            #1;

            check_outputs(16'h2000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Sign (0.5 * -0.5)", test_num);
            A = 8'h40;
            B = 8'hC0;
            #1;

            check_outputs(16'hE000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative * Negative (-0.25 * -0.5)", test_num);
            A = 8'hE0;
            B = 8'hC0;
            #1;

            check_outputs(16'h1000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Positive (0.99 * 0.99)", test_num);
            A = 8'h7F;
            B = 8'h7F;
            #1;

            check_outputs(16'h7E02);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Saturation (-1.0 * -1.0)", test_num);
            A = 8'h80;
            B = 8'h80;
            #1;

            check_outputs(16'h7FFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative Boundary (-1.0 * 0.99)", test_num);
            A = 8'h80;
            B = 8'h7F;
            #1;

            check_outputs(16'h8100);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Smallest Product", test_num);
            A = 8'h01;
            B = 8'h01;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("FixedPointMultiplier Testbench");
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
        input [15:0] expected_Result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Result === (expected_Result ^ Result ^ expected_Result)) begin
                $display("PASS");
                $display("  Outputs: Result=%h",
                         Result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Result=%h",
                         expected_Result);
                $display("  Got:      Result=%h",
                         Result);
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
