`timescale 1ns/1ps

module power_gating_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg enable;
    reg power_gating;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gating dut (
        .A(A),
        .B(B),
        .C(C),
        .enable(enable),
        .power_gating(power_gating),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial State - Enable low, output should hold initial 0", test_num);

            enable = 0;
            power_gating = 0;
            A = 1; B = 1; C = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Normal Operation - Enable=1, PG=0, A&B&C=1", test_num);

            enable = 1; power_gating = 1; #5;

            enable = 1;
            power_gating = 0;
            A = 1; B = 1; C = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Normal Operation - Enable=1, PG=0, A&B&C=0", test_num);
            enable = 1; power_gating = 1; #5;
            enable = 1;
            power_gating = 0;
            A = 1; B = 0; C = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Power Gating Active - Enable=1, PG=1", test_num);
            enable = 1; power_gating = 0; A = 1; B = 1; C = 1; #5;
            enable = 1;
            power_gating = 1;
            A = 1; B = 1; C = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Hold Mode - Holding High Value", test_num);

            enable = 1; power_gating = 0; A = 1; B = 1; C = 1;
            #5;

            enable = 0;
            #5;

            A = 0; B = 0; C = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Hold Mode - Holding Low Value", test_num);

            enable = 1; power_gating = 0; A = 1; B = 0; C = 1;
            #5;

            enable = 0;
            #5;

            A = 1; B = 1; C = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Hold Mode takes precedence over PG signal", test_num);

            enable = 1; power_gating = 0; A = 1; B = 1; C = 1;
            #5;

            enable = 0;
            #5;

            power_gating = 1;
            #1;

            check_outputs(1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("power_gating Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
                         Y);
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
