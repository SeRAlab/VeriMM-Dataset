`timescale 1ns/1ps

module unsigned_comparator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire EQ;
    wire GT;
    wire LT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    unsigned_comparator dut (
        .A(A),
        .B(B),
        .EQ(EQ),
        .GT(GT),
        .LT(LT)
    );
    task testcase001;

        begin
            $display("Running testcase001: A=0, B=0 (Equality)");
            A = 4'd0;
            B = 4'd0;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: A=15, B=15 (Max Equality)");
            A = 4'd15;
            B = 4'd15;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: A=8, B=8 (Mid Equality)");
            A = 4'd8;
            B = 4'd8;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: A=1, B=0 (A > B)");
            A = 4'd1;
            B = 4'd0;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: A=15, B=0 (Extreme A > B)");
            A = 4'd15;
            B = 4'd0;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: A=10, B=5 (A > B)");
            A = 4'd10;
            B = 4'd5;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: A=0, B=1 (A < B)");
            A = 4'd0;
            B = 4'd1;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: A=0, B=15 (Extreme A < B)");
            A = 4'd0;
            B = 4'd15;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase009;

        begin
            $display("Running testcase009: A=7, B=8 (A < B)");
            A = 4'd7;
            B = 4'd8;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase010;

        begin
            $display("Running testcase010: A=14, B=15 (A < B)");
            A = 4'd14;
            B = 4'd15;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("unsigned_comparator Testbench");
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
        input expected_EQ;
        input expected_GT;
        input expected_LT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EQ === (expected_EQ ^ EQ ^ expected_EQ) &&
                expected_GT === (expected_GT ^ GT ^ expected_GT) &&
                expected_LT === (expected_LT ^ LT ^ expected_LT)) begin
                $display("PASS");
                $display("  Outputs: EQ=%b, GT=%b, LT=%b",
                         EQ, GT, LT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EQ=%b, GT=%b, LT=%b",
                         expected_EQ, expected_GT, expected_LT);
                $display("  Got:      EQ=%b, GT=%b, LT=%b",
                         EQ, GT, LT);
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
