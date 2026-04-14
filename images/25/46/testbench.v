`timescale 1ns/1ps

module svm_classifier_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] b;
    reg [1:0] w1;
    reg [1:0] w2;
    reg [1:0] x1;
    reg [1:0] x2;
    wire decision;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    svm_classifier dut (
        .b(b),
        .w1(w1),
        .w2(w2),
        .x1(x1),
        .x2(x2),
        .decision(decision)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: All inputs zero (Sum = 0)", test_num);
        w1 = 2'd0; x1 = 2'd0;
        w2 = 2'd0; x2 = 2'd0;
        b = 2'd0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Bias only (Sum = 1)", test_num);
        w1 = 2'd0; x1 = 2'd0;
        w2 = 2'd0; x2 = 2'd0;
        b = 2'd1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: x1 contribution only (Sum = 1)", test_num);
        w1 = 2'd1; x1 = 2'd1;
        w2 = 2'd0; x2 = 2'd0;
        b = 2'd0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: x2 contribution only (Sum = 1)", test_num);
        w1 = 2'd0; x1 = 2'd0;
        w2 = 2'd1; x2 = 2'd1;
        b = 2'd0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Non-zero weights but zero coordinates (Sum = 0)", test_num);
        w1 = 2'd3; x1 = 2'd0;
        w2 = 2'd3; x2 = 2'd0;
        b = 2'd0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Maximum values (Sum = 21)", test_num);
        w1 = 2'd3; x1 = 2'd3;
        w2 = 2'd3; x2 = 2'd3;
        b = 2'd3;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Weights set, but x inputs 0, bias 0 (Sum = 0)", test_num);
        w1 = 2'd2; x1 = 2'd0;
        w2 = 2'd2; x2 = 2'd0;
        b = 2'd0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Specific coordinate classification (Sum = 4)", test_num);
        w1 = 2'd2; x1 = 2'd1;
        w2 = 2'd1; x2 = 2'd2;
        b = 2'd0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Coordinates set, weights 0, bias 0 (Sum = 0)", test_num);
        w1 = 2'd0; x1 = 2'd3;
        w2 = 2'd0; x2 = 2'd3;
        b = 2'd0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Large weights, small coordinates (Sum = 6)", test_num);
        w1 = 2'd3; x1 = 2'd1;
        w2 = 2'd3; x2 = 2'd1;
        b = 2'd0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("svm_classifier Testbench");
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
