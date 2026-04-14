`timescale 1ns/1ps

module SVM_Classifier_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] bias;
    reg clk;
    reg [7:0] feature1;
    reg [7:0] feature2;
    reg reset;
    reg [7:0] weight1;
    reg [7:0] weight2;
    wire label;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SVM_Classifier dut (
        .bias(bias),
        .clk(clk),
        .feature1(feature1),
        .feature2(feature2),
        .reset(reset),
        .weight1(weight1),
        .weight2(weight2),
        .label(label)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            feature1 = 0;
            feature2 = 0;
            weight1 = 0;
            weight2 = 0;
            bias = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Simple Positive Result", test_num);
            reset_dut();
            feature1 = 8'sd10; weight1 = 8'sd2;
            feature2 = 8'sd5;  weight2 = 8'sd3;
            bias     = 8'sd10;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Simple Negative Result", test_num);
            reset_dut();
            feature1 = 8'sd10; weight1 = 8'sd2;
            feature2 = 8'sd5;  weight2 = 8'sd3;
            bias     = -8'sd100;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Zero Boundary Condition", test_num);
            reset_dut();
            feature1 = -8'sd10; weight1 = 8'sd2;
            feature2 = 8'sd5;   weight2 = 8'sd4;
            bias     = 8'sd0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Negative Weights", test_num);
            reset_dut();
            feature1 = 8'sd10;  weight1 = -8'sd10;
            feature2 = 8'sd10;  weight2 = -8'sd5;
            bias     = 8'sd127;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Large Positive Limits", test_num);
            reset_dut();
            feature1 = 8'sd127; weight1 = 8'sd1;
            feature2 = 8'sd1;   weight2 = 8'sd1;
            bias     = -8'sd128;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Negative Multiplications", test_num);
            reset_dut();
            feature1 = -8'sd10; weight1 = -8'sd5;
            feature2 = -8'sd2;  weight2 = -8'sd10;
            bias     = -8'sd80;
            repeat(2) @(posedge clk);
            #1 #1;
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
        $display("SVM_Classifier Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input expected_label;
        begin
            if (expected_label === (expected_label ^ label ^ expected_label)) begin
                $display("PASS");
                $display("  Outputs: label=%b",
                         label);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: label=%b",
                         expected_label);
                $display("  Got:      label=%b",
                         label);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,bias, clk, feature1, feature2, reset, weight1, weight2, label);
    end

endmodule
