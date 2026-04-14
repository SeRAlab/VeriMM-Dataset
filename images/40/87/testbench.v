`timescale 1ns/1ps

module decision_tree_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] feature1;
    reg [3:0] feature2;
    reg [3:0] feature3;
    wire decision;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decision_tree dut (
        .feature1(feature1),
        .feature2(feature2),
        .feature3(feature3),
        .decision(decision)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Testing feature1 < 5 (f1=2, f2=0, f3=0)", test_num);
        feature1 = 4'd2; feature2 = 4'd0; feature3 = 4'd0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Testing feature1 < 5 (f1=4, f2=15, f3=15)", test_num);
        feature1 = 4'd4; feature2 = 4'd15; feature3 = 4'd15;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Testing f1 >= 5, f2 < 10 (f1=5, f2=0, f3=0)", test_num);
        feature1 = 4'd5; feature2 = 4'd0; feature3 = 4'd0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Testing f1 >= 5, f2 < 10 (f1=15, f2=9, f3=15)", test_num);
        feature1 = 4'd15; feature2 = 4'd9; feature3 = 4'd15;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Testing f1 >= 5, f2 >= 10, f3 < 15 (f1=5, f2=10, f3=0)", test_num);
        feature1 = 4'd5; feature2 = 4'd10; feature3 = 4'd0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Testing f1 >= 5, f2 >= 10, f3 < 15 (f1=10, f2=15, f3=14)", test_num);
        feature1 = 4'd10; feature2 = 4'd15; feature3 = 4'd14;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Testing f1 >= 5, f2 >= 10, f3 >= 15 (f1=5, f2=10, f3=15)", test_num);
        feature1 = 4'd5; feature2 = 4'd10; feature3 = 4'd15;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Testing f1 >= 5, f2 >= 10, f3 >= 15 (f1=15, f2=15, f3=15)", test_num);
        feature1 = 4'd15; feature2 = 4'd15; feature3 = 4'd15;
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
        $display("decision_tree Testbench");
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
