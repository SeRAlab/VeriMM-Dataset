`timescale 1ns/1ps

module QR_decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    wire [15:0] Q;
    wire [15:0] R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    QR_decomposition dut (
        .A(A),
        .Q(Q),
        .R(R)
    );
    task testcase001;

        begin
            $display("\nTestcase 001: Identity Matrix");
            test_num = 1;
            A = 16'h1001;
            #1;

            check_outputs(16'h1001, 16'h1001);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Scaled Identity Matrix");
            test_num = 2;
            A = 16'h2002;
            #1;

            check_outputs(16'h1001, 16'h2002);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Upper Triangular Matrix");
            test_num = 3;
            A = 16'h1203;
            #1;

            check_outputs(16'h1001, 16'h1203);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Column Swap Matrix");
            test_num = 4;
            A = 16'h0110;
            #1;

            check_outputs(16'h0110, 16'h1001);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Scaled Upper Triangular");
            test_num = 5;
            A = 16'h3303;
            #1;

            check_outputs(16'h1001, 16'h3303);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Singular Matrix (Row 2 all zeros)");
            test_num = 6;
            A = 16'h1100;
            #1;

            check_outputs(16'h1001, 16'h1100);
        end
        endtask

    task testcase007;

        begin
            $display("\nTestcase 007: Shifted Basis");
            test_num = 7;
            A = 16'h0022;
            #1;

            check_outputs(16'h0110, 16'h2200);
        end
        endtask

    task testcase008;

        begin
            $display("\nTestcase 008: All Zeros Matrix");
            test_num = 8;
            A = 16'h0000;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("QR_decomposition Testbench");
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
        input [15:0] expected_Q;
        input [15:0] expected_R;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_R === (expected_R ^ R ^ expected_R)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, R=%h",
                         Q, R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, R=%h",
                         expected_Q, expected_R);
                $display("  Got:      Q=%h, R=%h",
                         Q, R);
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
