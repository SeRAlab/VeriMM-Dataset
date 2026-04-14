`timescale 1ns/1ps

module svm_classifier_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] w1;
    reg [7:0] w2;
    reg [7:0] x1;
    reg [7:0] x2;
    wire decision;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    svm_classifier dut (
        .w1(w1),
        .w2(w2),
        .x1(x1),
        .x2(x2),
        .decision(decision)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Positive weighted sum (Positive Inputs)", test_num);
        w1 = 8'd10; x1 = 8'd2; w2 = 8'd5; x2 = 8'd4;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All zeros input", test_num);
        w1 = 8'd0; x1 = 8'd0; w2 = 8'd0; x2 = 8'd0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Negative weighted sum", test_num);
        w1 = 8'hFB; x1 = 8'h02; w2 = 8'hFD; x2 = 8'h04;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mixed signs resulting in 1", test_num);
        w1 = 8'd10; x1 = 8'hFE; w2 = 8'd21; x2 = 8'd01;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sum equals zero boundary", test_num);
        w1 = 8'd10; x1 = 8'hFE; w2 = 8'd20; x2 = 8'd01;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Large positive weighted sum", test_num);
        w1 = 8'h7F; x1 = 8'd1; w2 = 8'h7F; x2 = 8'd1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Large negative weighted sum", test_num);
        w1 = 8'hFF; x1 = 8'h7F; w2 = 8'hFF; x2 = 8'h7F;
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
        $display("svm_classifier Testbench");
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
