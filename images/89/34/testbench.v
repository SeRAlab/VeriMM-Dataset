`timescale 1ns/1ps

module state_machine_tb;

    // Testbench signals (combinational circuit)
    reg r;
    reg [3:0] s;
    wire S2;
    wire S3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    state_machine dut (
        .r(r),
        .s(s),
        .S2(S2),
        .S3(S3)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: State A (0001), r=0 -> Target B (S2=1)");
            r = 1'b0; s = 4'b0001;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: State A (0001), r=1 -> Target C (S3=1)");
            r = 1'b1; s = 4'b0001;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: State B (0010), r=0 -> Target A (S2=0, S3=0)");
            r = 1'b0; s = 4'b0010;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: State B (0010), r=1 -> Target D (S2=0, S3=0)");
            r = 1'b1; s = 4'b0010;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: State C (0100), r=0 -> Target D (S2=0, S3=0)");
            r = 1'b0; s = 4'b0100;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: State C (0100), r=1 -> Target A (S2=0, S3=0)");
            r = 1'b1; s = 4'b0100;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: State D (1000), r=0 -> Target B (S2=1)");
            r = 1'b0; s = 4'b1000;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: State D (1000), r=1 -> Target C (S3=1)");
            r = 1'b1; s = 4'b1000;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("state_machine Testbench");
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
        input expected_S2;
        input expected_S3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S2 === (expected_S2 ^ S2 ^ expected_S2) &&
                expected_S3 === (expected_S3 ^ S3 ^ expected_S3)) begin
                $display("PASS");
                $display("  Outputs: S2=%b, S3=%b",
                         S2, S3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S2=%b, S3=%b",
                         expected_S2, expected_S3);
                $display("  Got:      S2=%b, S3=%b",
                         S2, S3);
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
