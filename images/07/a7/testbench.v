`timescale 1ns/1ps

module heap_sort_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [3:0] D;
    wire [3:0] S0;
    wire [3:0] S1;
    wire [3:0] S2;
    wire [3:0] S3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    heap_sort dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .S0(S0),
        .S1(S1),
        .S2(S2),
        .S3(S3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: All Zeros");
            A = 4'd0; B = 4'd0; C = 4'd0; D = 4'd0;
            #1;

            check_outputs(4'd0, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: All Max Values");
            A = 4'd15; B = 4'd15; C = 4'd15; D = 4'd15;
            #1;

            check_outputs(4'd15, 4'd15, 4'd15, 4'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Already Sorted");
            A = 4'd1; B = 4'd5; C = 4'd10; D = 4'd14;
            #1;

            check_outputs(4'd1, 4'd5, 4'd10, 4'd14);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Reverse Sorted");
            A = 4'd15; B = 4'd10; C = 4'd5; D = 4'd2;
            #1;

            check_outputs(4'd2, 4'd5, 4'd10, 4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Mixed Order 1");
            A = 4'd7; B = 4'd1; C = 4'd9; D = 4'd3;
            #1;

            check_outputs(4'd1, 4'd3, 4'd7, 4'd9);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: Mixed Order 2");
            A = 4'd2; B = 4'd11; C = 4'd0; D = 4'd8;
            #1;

            check_outputs(4'd0, 4'd2, 4'd8, 4'd11);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case 007: Duplicates (Two Pairs)");
            A = 4'd4; B = 4'd12; C = 4'd4; D = 4'd12;
            #1;

            check_outputs(4'd4, 4'd4, 4'd12, 4'd12);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case 008: Duplicates (Three Same)");
            A = 4'd6; B = 4'd6; C = 4'd1; D = 4'd6;
            #1;

            check_outputs(4'd1, 4'd6, 4'd6, 4'd6);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case 009: One Very Large, Others Small");
            A = 4'd1; B = 4'd2; C = 4'd15; D = 4'd0;
            #1;

            check_outputs(4'd0, 4'd1, 4'd2, 4'd15);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case 010: All Different Shuffled");
            A = 4'd13; B = 4'd4; C = 4'd11; D = 4'd6;
            #1;

            check_outputs(4'd4, 4'd6, 4'd11, 4'd13);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("heap_sort Testbench");
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
        input [3:0] expected_S0;
        input [3:0] expected_S1;
        input [3:0] expected_S2;
        input [3:0] expected_S3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S0 === (expected_S0 ^ S0 ^ expected_S0) &&
                expected_S1 === (expected_S1 ^ S1 ^ expected_S1) &&
                expected_S2 === (expected_S2 ^ S2 ^ expected_S2) &&
                expected_S3 === (expected_S3 ^ S3 ^ expected_S3)) begin
                $display("PASS");
                $display("  Outputs: S0=%h, S1=%h, S2=%h, S3=%h",
                         S0, S1, S2, S3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S0=%h, S1=%h, S2=%h, S3=%h",
                         expected_S0, expected_S1, expected_S2, expected_S3);
                $display("  Got:      S0=%h, S1=%h, S2=%h, S3=%h",
                         S0, S1, S2, S3);
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
