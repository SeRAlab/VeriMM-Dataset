`timescale 1ns/1ps

module svm_classifier_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] b;
    reg [7:0] w1;
    reg [7:0] w2;
    reg [7:0] x1;
    reg [7:0] x2;
    wire classification;

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
        .classification(classification)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Positive Result (w1*x1 + w2*x2 + b > 0)", test_num);
            w1 = 8'sd2;  x1 = 8'sd5;
            w2 = 8'sd3;  x2 = 8'sd10;
            b  = 8'sd5;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Negative Result (w1*x1 + w2*x2 + b < 0)", test_num);
            w1 = 8'shFE;
            x1 = 8'sd5;
            w2 = 8'shFD;
            x2 = 8'sd10;
            b  = 8'sd5;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary Result (Sum equals 0)", test_num);
            w1 = 8'sd1;  x1 = 8'sd10;
            w2 = 8'shFF;
            x2 = 8'sd10;
            b  = 8'sd0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Small Positive (Sum equals 1)", test_num);
            w1 = 8'sd1;  x1 = 8'sd10;
            w2 = 8'shFF;
            x2 = 8'sd10;
            b  = 8'sd1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mixed signs with Bias shifting to Negative", test_num);
            w1 = 8'sd10; x1 = 8'sd2;
            w2 = 8'sd5;  x2 = 8'sd4;
            b  = 8'shD8;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Negative Features with Negative Weights (Positive Sum)", test_num);
            w1 = 8'shF6;
            x1 = 8'shF6;
            w2 = 8'shF6;
            x2 = 8'shF6;
            b  = 8'sh9C;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large range test (Max Positives)", test_num);
            w1 = 8'sd127; x1 = 8'sd1;
            w2 = 8'sd0;   x2 = 8'sd0;
            b  = 8'sh81;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large range test (Min Negatives)", test_num);
            w1 = 8'sh80;
            x1 = 8'sd1;
            w2 = 8'sd0;   x2 = 8'sd0;
            b  = 8'sd127;

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
        input expected_classification;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_classification === (expected_classification ^ classification ^ expected_classification)) begin
                $display("PASS");
                $display("  Outputs: classification=%b",
                         classification);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: classification=%b",
                         expected_classification);
                $display("  Got:      classification=%b",
                         classification);
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
