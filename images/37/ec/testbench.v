`timescale 1ns/1ps

module decision_tree_inference_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] features;
    wire decision;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decision_tree_inference dut (
        .features(features),
        .decision(decision)
    );
    task testcase001;

    begin
        $display("\nRunning testcase001: Rule 1 (f0=1)");
        test_num = 1;
        features = 5'b00001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("\nRunning testcase002: Rule 1 Priority (f0=1, f1=1, f2=0)");
        test_num = 2;
        features = 5'b00011;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("\nRunning testcase003: Rule 2 (f0=0, f1=1, f2=0)");
        test_num = 3;
        features = 5'b00010;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("\nRunning testcase004: Rule 2 vs Rule 3 (f0=0, f1=1, f2=0, f3=1)");
        test_num = 4;
        features = 5'b01010;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("\nRunning testcase005: Rule 3 (f0=0, f1=0, f3=1)");
        test_num = 5;
        features = 5'b01000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        $display("\nRunning testcase006: Rule 3 vs Rule 4 (f0=0, f1=0, f3=1, f4=0)");
        test_num = 6;
        features = 5'b01000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        $display("\nRunning testcase007: Rule 4 (f0=0, f1=0, f3=0, f4=1)");
        test_num = 7;
        features = 5'b10000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        $display("\nRunning testcase008: Rule 4 (f0=0, f1=0, f3=0, f4=0)");
        test_num = 8;
        features = 5'b00000;
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
        $display("decision_tree_inference Testbench");
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
        input expected_decision;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_decision === (expected_decision ^ decision ^ expected_decision)) begin
                $display("PASS");
                $display("  Outputs: decision=%b",
                         decision);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decision=%b",
                         expected_decision);
                $display("  Got:      decision=%b",
                         decision);
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
