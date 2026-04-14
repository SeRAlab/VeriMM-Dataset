`timescale 1ns/1ps

module priority_encoder_tb;

    // Testbench signals (combinational circuit)
    reg I0;
    reg I1;
    reg I2;
    reg I3;
    wire O0;
    wire O1;
    wire V;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder dut (
        .I0(I0),
        .I1(I1),
        .I2(I2),
        .I3(I3),
        .O0(O0),
        .O1(O1),
        .V(V)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All inputs low", test_num);
        I3 = 0; I2 = 0; I1 = 0; I0 = 0;
        #1;

        check_outputs(0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: I0 only active (Priority 0)", test_num);
        I3 = 0; I2 = 0; I1 = 0; I0 = 1;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: I1 only active (Priority 1)", test_num);
        I3 = 0; I2 = 0; I1 = 1; I0 = 0;
        #1;

        check_outputs(1, 0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: I2 only active (Priority 2)", test_num);
        I3 = 0; I2 = 1; I1 = 0; I0 = 0;
        #1;

        check_outputs(0, 1, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: I3 only active (Priority 3)", test_num);
        I3 = 1; I2 = 0; I1 = 0; I0 = 0;
        #1;

        check_outputs(1, 1, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: I3 and I0 active (I3 should take priority)", test_num);
        I3 = 1; I2 = 0; I1 = 0; I0 = 1;
        #1;

        check_outputs(1, 1, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: I2 and I1 active (I2 should take priority)", test_num);
        I3 = 0; I2 = 1; I1 = 1; I0 = 0;
        #1;

        check_outputs(0, 1, 1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: I1 and I0 active (I1 should take priority)", test_num);
        I3 = 0; I2 = 0; I1 = 1; I0 = 1;
        #1;

        check_outputs(1, 0, 1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All inputs active (I3 should take priority)", test_num);
        I3 = 1; I2 = 1; I1 = 1; I0 = 1;
        #1;

        check_outputs(1, 1, 1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: I3, I2, I1 active (I3 should take priority)", test_num);
        I3 = 1; I2 = 1; I1 = 1; I0 = 0;
        #1;

        check_outputs(1, 1, 1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_encoder Testbench");
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
        input expected_O0;
        input expected_O1;
        input expected_V;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O0 === (expected_O0 ^ O0 ^ expected_O0) &&
                expected_O1 === (expected_O1 ^ O1 ^ expected_O1) &&
                expected_V === (expected_V ^ V ^ expected_V)) begin
                $display("PASS");
                $display("  Outputs: O0=%b, O1=%b, V=%b",
                         O0, O1, V);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O0=%b, O1=%b, V=%b",
                         expected_O0, expected_O1, expected_V);
                $display("  Got:      O0=%b, O1=%b, V=%b",
                         O0, O1, V);
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
