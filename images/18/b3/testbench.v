`timescale 1ns/1ps

module hazard_detection_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    wire hazard;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hazard_detection dut (
        .A(A),
        .B(B),
        .C(C),
        .hazard(hazard)
    );
    task reset_inputs;

        input rA, rB, rC;
        begin
            A = rA; B = rB; C = rC;
            #10;
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Transition 000 -> 011 (B, C change)", test_num);
        reset_inputs(0, 0, 0);
        A = 0; B = 1; C = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Transition 000 -> 101 (A, C change)", test_num);
        reset_inputs(0, 0, 0);
        A = 1; B = 0; C = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Transition 000 -> 110 (A, B change)", test_num);
        reset_inputs(0, 0, 0);
        A = 1; B = 1; C = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Transition 000 -> 001 (Only C changes)", test_num);
        reset_inputs(0, 0, 0);
        A = 0; B = 0; C = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Transition 000 -> 111 (All change)", test_num);
        reset_inputs(0, 0, 0);
        A = 1; B = 1; C = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Transition 111 -> 100 (B, C change)", test_num);
        reset_inputs(1, 1, 1);
        A = 1; B = 0; C = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Transition 111 -> 011 (Only A changes)", test_num);
        reset_inputs(1, 1, 1);
        A = 0; B = 1; C = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Transition 010 -> 010 (No change)", test_num);
        reset_inputs(0, 1, 0);
        A = 0; B = 1; C = 0;
        #1;

        check_outputs(1'b0);
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
        input expected_hazard;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hazard === (expected_hazard ^ hazard ^ expected_hazard)) begin
                $display("PASS");
                $display("  Outputs: hazard=%b",
                         hazard);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hazard=%b",
                         expected_hazard);
                $display("  Got:      hazard=%b",
                         hazard);
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
