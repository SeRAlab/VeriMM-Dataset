`timescale 1ns/1ps

module hazard_detection_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    wire F;
    wire hazard_detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hazard_detection dut (
        .A(A),
        .B(B),
        .C(C),
        .F(F),
        .hazard_detected(hazard_detected)
    );
    task testcase001;

    begin
        $display("Testcase 001: All inputs low (A=0, B=0, C=0)");
        test_num = 1;
        A = 1'b0; B = 1'b0; C = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: C active (A=0, B=0, C=1)");
        test_num = 2;
        A = 1'b0; B = 1'b0; C = 1'b1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: B active (A=0, B=1, C=0)");
        test_num = 3;
        A = 1'b0; B = 1'b1; C = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Potential Static-1 Hazard Zone (A=0, B=1, C=1)");
        test_num = 4;
        A = 1'b0; B = 1'b1; C = 1'b1;

        #1;


        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: A active only (A=1, B=0, C=0)");
        test_num = 5;
        A = 1'b1; B = 1'b0; C = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: A and C active (A=1, B=0, C=1)");
        test_num = 6;
        A = 1'b1; B = 1'b0; C = 1'b1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: A and B active (A=1, B=1, C=0)");
        test_num = 7;
        A = 1'b1; B = 1'b1; C = 1'b0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: All inputs high - Hazard Zone (A=1, B=1, C=1)");
        test_num = 8;
        A = 1'b1; B = 1'b1; C = 1'b1;

        #1;


        check_outputs(1'b1, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hazard_detection Testbench");
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
        input expected_F;
        input expected_hazard_detected;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_F === (expected_F ^ F ^ expected_F) &&
                expected_hazard_detected === (expected_hazard_detected ^ hazard_detected ^ expected_hazard_detected)) begin
                $display("PASS");
                $display("  Outputs: F=%b, hazard_detected=%b",
                         F, hazard_detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: F=%b, hazard_detected=%b",
                         expected_F, expected_hazard_detected);
                $display("  Got:      F=%b, hazard_detected=%b",
                         F, hazard_detected);
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
