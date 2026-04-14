`timescale 1ns/1ps

module knn_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] feature1_1;
    reg [7:0] feature1_2;
    reg [7:0] feature1_3;
    reg [7:0] feature1_4;
    reg [7:0] feature1_5;
    reg [7:0] feature2_1;
    reg [7:0] feature2_2;
    reg [7:0] feature2_3;
    reg [7:0] feature2_4;
    reg [7:0] feature2_5;
    wire same_class;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    knn dut (
        .feature1_1(feature1_1),
        .feature1_2(feature1_2),
        .feature1_3(feature1_3),
        .feature1_4(feature1_4),
        .feature1_5(feature1_5),
        .feature2_1(feature2_1),
        .feature2_2(feature2_2),
        .feature2_3(feature2_3),
        .feature2_4(feature2_4),
        .feature2_5(feature2_5),
        .same_class(same_class)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identical samples", test_num);
            feature1_1 = 8'd50; feature1_2 = 8'd50; feature1_3 = 8'd50; feature1_4 = 8'd50; feature1_5 = 8'd50;
            feature2_1 = 8'd50; feature2_2 = 8'd50; feature2_3 = 8'd50; feature2_4 = 8'd50; feature2_5 = 8'd50;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Small differences", test_num);
            feature1_1 = 8'd10; feature1_2 = 8'd20; feature1_3 = 8'd30; feature1_4 = 8'd40; feature1_5 = 8'd50;
            feature2_1 = 8'd11; feature2_2 = 8'd21; feature2_3 = 8'd31; feature2_4 = 8'd41; feature2_5 = 8'd51;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large differences", test_num);
            feature1_1 = 8'd100; feature1_2 = 8'd100; feature1_3 = 8'd100; feature1_4 = 8'd100; feature1_5 = 8'd100;
            feature2_1 = 8'd150; feature2_2 = 8'd150; feature2_3 = 8'd150; feature2_4 = 8'd150; feature2_5 = 8'd150;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum distance", test_num);
            feature1_1 = 8'd255; feature1_2 = 8'd255; feature1_3 = 8'd255; feature1_4 = 8'd255; feature1_5 = 8'd255;
            feature2_1 = 8'd0;   feature2_2 = 8'd0;   feature2_3 = 8'd0;   feature2_4 = 8'd0;   feature2_5 = 8'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Moderate differences", test_num);
            feature1_1 = 8'd120; feature1_2 = 8'd120; feature1_3 = 8'd120; feature1_4 = 8'd120; feature1_5 = 8'd120;
            feature2_1 = 8'd130; feature2_2 = 8'd130; feature2_3 = 8'd130; feature2_4 = 8'd130; feature2_5 = 8'd130;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single feature outlier", test_num);
            feature1_1 = 8'd40; feature1_2 = 8'd10; feature1_3 = 8'd10; feature1_4 = 8'd10; feature1_5 = 8'd10;
            feature2_1 = 8'd80; feature2_2 = 8'd10; feature2_3 = 8'd10; feature2_4 = 8'd10; feature2_5 = 8'd10;
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
        $display("knn Testbench");
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
        input expected_same_class;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_same_class === (expected_same_class ^ same_class ^ expected_same_class)) begin
                $display("PASS");
                $display("  Outputs: same_class=%b",
                         same_class);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: same_class=%b",
                         expected_same_class);
                $display("  Got:      same_class=%b",
                         same_class);
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
