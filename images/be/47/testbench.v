`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire AeqB;
    wire AgtB;
    wire AltB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .AeqB(AeqB),
        .AgtB(AgtB),
        .AltB(AltB)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A = 0, B = 0 (Equality)", test_num);
            A = 4'd0;
            B = 4'd0;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A = 15, B = 15 (Equality Max)", test_num);
            A = 4'd15;
            B = 4'd15;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A = 5, B = 5 (Equality Mid)", test_num);
            A = 4'd5;
            B = 4'd5;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A = 1, B = 0 (A > B Boundary)", test_num);
            A = 4'd1;
            B = 4'd0;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A = 15, B = 0 (A >> B)", test_num);
            A = 4'd15;
            B = 4'd0;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A = 10, B = 5 (A > B Mid)", test_num);
            A = 4'd10;
            B = 4'd5;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A = 0, B = 1 (A < B Boundary)", test_num);
            A = 4'd0;
            B = 4'd1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A = 0, B = 15 (A << B)", test_num);
            A = 4'd0;
            B = 4'd15;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A = 7, B = 8 (A < B Adjacent)", test_num);
            A = 4'd7;
            B = 4'd8;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A = 12, B = 13 (A < B Mid)", test_num);
            A = 4'd12;
            B = 4'd13;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
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
        input expected_AeqB;
        input expected_AgtB;
        input expected_AltB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_AeqB === (expected_AeqB ^ AeqB ^ expected_AeqB) &&
                expected_AgtB === (expected_AgtB ^ AgtB ^ expected_AgtB) &&
                expected_AltB === (expected_AltB ^ AltB ^ expected_AltB)) begin
                $display("PASS");
                $display("  Outputs: AeqB=%b, AgtB=%b, AltB=%b",
                         AeqB, AgtB, AltB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AeqB=%b, AgtB=%b, AltB=%b",
                         expected_AeqB, expected_AgtB, expected_AltB);
                $display("  Got:      AeqB=%b, AgtB=%b, AltB=%b",
                         AeqB, AgtB, AltB);
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
