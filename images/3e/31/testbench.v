`timescale 1ns/1ps

module encoder_4to2_tb;

    // Testbench signals (combinational circuit)
    reg I0;
    reg I1;
    reg I2;
    reg I3;
    wire Y0;
    wire Y1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    encoder_4to2 dut (
        .I0(I0),
        .I1(I1),
        .I2(I2),
        .I3(I3),
        .Y0(Y0),
        .Y1(Y1)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Assert I0 only", test_num);
            I3 = 0; I2 = 0; I1 = 0; I0 = 1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Assert I1 only", test_num);
            I3 = 0; I2 = 0; I1 = 1; I0 = 0;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Assert I2 only", test_num);
            I3 = 0; I2 = 1; I1 = 0; I0 = 0;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Assert I3 only", test_num);
            I3 = 1; I2 = 0; I1 = 0; I0 = 0;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority Check - I3 asserted with all others", test_num);
            I3 = 1; I2 = 1; I1 = 1; I0 = 1;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority Check - I2 asserted with I1, I0", test_num);
            I3 = 0; I2 = 1; I1 = 1; I0 = 1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority Check - I1 asserted with I0", test_num);
            I3 = 0; I2 = 0; I1 = 1; I0 = 1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority Check - I3 and I1 asserted", test_num);
            I3 = 1; I2 = 0; I1 = 1; I0 = 0;
            #1;

            check_outputs(1, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("encoder_4to2 Testbench");
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
        input expected_Y0;
        input expected_Y1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y0 === (expected_Y0 ^ Y0 ^ expected_Y0) &&
                expected_Y1 === (expected_Y1 ^ Y1 ^ expected_Y1)) begin
                $display("PASS");
                $display("  Outputs: Y0=%b, Y1=%b",
                         Y0, Y1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y0=%b, Y1=%b",
                         expected_Y0, expected_Y1);
                $display("  Got:      Y0=%b, Y1=%b",
                         Y0, Y1);
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
