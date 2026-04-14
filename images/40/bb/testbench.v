`timescale 1ns/1ps

module decoder_2to4_tb;

    // Testbench signals (combinational circuit)
    reg A0;
    reg A1;
    wire Y0;
    wire Y1;
    wire Y2;
    wire Y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_2to4 dut (
        .A0(A0),
        .A1(A1),
        .Y0(Y0),
        .Y1(Y1),
        .Y2(Y2),
        .Y3(Y3)
    );
    task testcase001;

        begin
            test_num = 1;
            A1 = 0; A0 = 0;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A1 = 0; A0 = 1;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A1 = 1; A0 = 0;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A1 = 1; A0 = 1;
            #1;

            check_outputs(0, 0, 0, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder_2to4 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_Y0;
        input expected_Y1;
        input expected_Y2;
        input expected_Y3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y0 === (expected_Y0 ^ Y0 ^ expected_Y0) &&
                expected_Y1 === (expected_Y1 ^ Y1 ^ expected_Y1) &&
                expected_Y2 === (expected_Y2 ^ Y2 ^ expected_Y2) &&
                expected_Y3 === (expected_Y3 ^ Y3 ^ expected_Y3)) begin
                $display("PASS");
                $display("  Outputs: Y0=%b, Y1=%b, Y2=%b, Y3=%b",
                         Y0, Y1, Y2, Y3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y0=%b, Y1=%b, Y2=%b, Y3=%b",
                         expected_Y0, expected_Y1, expected_Y2, expected_Y3);
                $display("  Got:      Y0=%b, Y1=%b, Y2=%b, Y3=%b",
                         Y0, Y1, Y2, Y3);
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
