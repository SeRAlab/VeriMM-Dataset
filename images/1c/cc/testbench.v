`timescale 1ns/1ps

module svm_decision_function_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] w1;
    reg [3:0] w2;
    reg [3:0] x1;
    reg [3:0] x2;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    svm_decision_function dut (
        .w1(w1),
        .w2(w2),
        .x1(x1),
        .x2(x2),
        .y(y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Positive dot product (All positive inputs)", test_num);
        w1 = 4'd2;
        w2 = 4'd3;
        x1 = 4'd1;
        x2 = 4'd1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Negative dot product (Negative weights)", test_num);
        w1 = 4'sb1110;
        w2 = 4'sb1101;
        x1 = 4'd2;
        x2 = 4'd1;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Zero dot product (Edge case)", test_num);
        w1 = 4'd0;
        w2 = 4'd0;
        x1 = 4'd5;
        x2 = 4'd5;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Mixed signs, resulting in positive", test_num);
        w1 = 4'sb0111;
        w2 = 4'sb1111;
        x1 = 4'd2;
        x2 = 4'd2;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Mixed signs, resulting in negative", test_num);
        w1 = 4'sb0010;
        w2 = 4'sb1100;
        x1 = 4'd3;
        x2 = 4'd2;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Large positive values (Max 4-bit signed)", test_num);
        w1 = 4'sb0111;
        w2 = 4'sb0111;
        x1 = 4'sb0111;
        x2 = 4'sb0111;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Large negative values (Min 4-bit signed)", test_num);
        w1 = 4'sb1000;
        w2 = 4'sb1000;
        x1 = 4'sb0111;
        x2 = 4'sb0111;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Negative features and negative weights", test_num);
        w1 = 4'sb1111;
        w2 = 4'sb1111;
        x1 = 4'sb1111;
        x2 = 4'sb1111;

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
        $display("svm_decision_function Testbench");
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
        input expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%b",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%b",
                         expected_y);
                $display("  Got:      y=%b",
                         y);
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
