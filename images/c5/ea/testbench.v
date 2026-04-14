`timescale 1ns/1ps

module Modulo_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    wire [31:0] Remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Modulo dut (
        .A(A),
        .B(B),
        .Remainder(Remainder)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple division with remainder (10 %% 3)", test_num);
            A = 32'd10;
            B = 32'd3;
            #1;

            check_outputs(32'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Exact division (20 %% 5)", test_num);
            A = 32'd20;
            B = 32'd5;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A less than B (5 %% 12)", test_num);
            A = 32'd5;
            B = 32'd12;
            #1;

            check_outputs(32'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Division by 1 (100 %% 1)", test_num);
            A = 32'd100;
            B = 32'd1;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large numbers (4294967295 %% 2)", test_num);
            A = 32'hFFFFFFFF;
            B = 32'd2;
            #1;

            check_outputs(32'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero dividend (0 %% 15)", test_num);
            A = 32'd0;
            B = 32'd15;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identical A and B (77 %% 77)", test_num);
            A = 32'd77;
            B = 32'd77;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large divisor (1000 %% 32'hFFFFFFFF)", test_num);
            A = 32'd1000;
            B = 32'hFFFFFFFF;
            #1;

            check_outputs(32'd1000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Modulo Testbench");
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
        input [31:0] expected_Remainder;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Remainder === (expected_Remainder ^ Remainder ^ expected_Remainder)) begin
                $display("PASS");
                $display("  Outputs: Remainder=%h",
                         Remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Remainder=%h",
                         expected_Remainder);
                $display("  Got:      Remainder=%h",
                         Remainder);
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
