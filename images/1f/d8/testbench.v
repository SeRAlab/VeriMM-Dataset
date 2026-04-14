`timescale 1ns/1ps

module svm_classifier_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] b;
    reg [4:0] w1;
    reg [4:0] w2;
    reg [4:0] w3;
    reg [4:0] w4;
    reg [4:0] w5;
    reg [4:0] x1;
    reg [4:0] x2;
    reg [4:0] x3;
    reg [4:0] x4;
    reg [4:0] x5;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    svm_classifier dut (
        .b(b),
        .w1(w1),
        .w2(w2),
        .w3(w3),
        .w4(w4),
        .w5(w5),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .x4(x4),
        .x5(x5),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (Boundary condition z=0)", test_num);
            b  = 5'd0;
            w1 = 5'd0; w2 = 5'd0; w3 = 5'd0; w4 = 5'd0; w5 = 5'd0;
            x1 = 5'd0; x2 = 5'd0; x3 = 5'd0; x4 = 5'd0; x5 = 5'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive Bias, Zero Weights", test_num);
            b  = 5'd5;
            w1 = 5'd0; w2 = 5'd0; w3 = 5'd0; w4 = 5'd0; w5 = 5'd0;
            x1 = 5'd0; x2 = 5'd0; x3 = 5'd0; x4 = 5'd0; x5 = 5'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative Bias, Zero Weights", test_num);
            b  = 5'b11111;
            w1 = 5'd0; w2 = 5'd0; w3 = 5'd0; w4 = 5'd0; w5 = 5'd0;
            x1 = 5'd0; x2 = 5'd0; x3 = 5'd0; x4 = 5'd0; x5 = 5'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Positive Dot Product", test_num);
            b  = 5'd0;
            w1 = 5'd2; w2 = 5'd0; w3 = 5'd0; w4 = 5'd0; w5 = 5'd0;
            x1 = 5'd3; x2 = 5'd0; x3 = 5'd0; x4 = 5'd0; x5 = 5'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Negative Dot Product", test_num);
            b  = 5'd0;
            w1 = 5'b11110;
            x1 = 5'd3;
            w2 = 5'd0; w3 = 5'd0; w4 = 5'd0; w5 = 5'd0;
            x2 = 5'd0; x3 = 5'd0; x4 = 5'd0; x5 = 5'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Dot Product Balanced by Bias to Zero", test_num);
            b  = 5'b11100;
            w1 = 5'd2;
            x1 = 5'd2;
            w2 = 5'd0; w3 = 5'd0; w4 = 5'd0; w5 = 5'd0;
            x2 = 5'd0; x3 = 5'd0; x4 = 5'd0; x5 = 5'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Negative Result", test_num);
            b  = 5'b10000;
            w1 = 5'b11111;
            w2 = 5'b11111;
            w3 = 5'b11111;
            w4 = 5'b11111;
            w5 = 5'b11111;
            x1 = 5'd15; x2 = 5'd15; x3 = 5'd15; x4 = 5'd15; x5 = 5'd15;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Positive Result", test_num);
            b  = 5'd15;
            w1 = 5'd15; w2 = 5'd15; w3 = 5'd15; w4 = 5'd15; w5 = 5'd15;
            x1 = 5'd15; x2 = 5'd15; x3 = 5'd15; x4 = 5'd15; x5 = 5'd15;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Weights and Inputs", test_num);
            b  = 5'b11111;
            w1 = 5'd2;     x1 = 5'd4;
            w2 = 5'b11110; x2 = 5'd3;
            w3 = 5'd1;     x3 = 5'd5;
            w4 = 5'b11100; x4 = 5'd1;
            w5 = 5'd2;     x5 = 5'd1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Result slightly below zero", test_num);
            b  = 5'b11111;
            w1 = 5'd1;     x1 = 5'd0;
            w2 = 5'd0;     x2 = 5'd0;
            w3 = 5'd0;     x3 = 5'd0;
            w4 = 5'd0;     x4 = 5'd0;
            w5 = 5'd0;     x5 = 5'd0;
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
