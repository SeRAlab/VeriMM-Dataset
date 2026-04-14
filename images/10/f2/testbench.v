`timescale 1ns/1ps

module decision_tree_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] feature1;
    reg [3:0] feature2;
    reg [3:0] feature3;
    wire [1:0] class_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decision_tree dut (
        .feature1(feature1),
        .feature2(feature2),
        .feature3(feature3),
        .class_out(class_out)
    );
    task testcase001;

        begin
            test_num = 1;
            feature1 = 4'd10;
            feature2 = 4'd5;
            feature3 = 4'd0;
            $display("Test Case %0d: feature1=10, feature2=5 (Class 1)", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            feature1 = 4'd8;
            feature2 = 4'd2;
            feature3 = 4'd1;
            $display("Test Case %0d: feature1=8, feature2=2 (Class 2)", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            feature1 = 4'd3;
            feature2 = 4'd10;
            feature3 = 4'd1;
            $display("Test Case %0d: feature1=3, feature3=1 (Class 3)", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            feature1 = 4'd2;
            feature2 = 4'd0;
            feature3 = 4'd5;
            $display("Test Case %0d: feature1=2, feature3=5 (Class 4)", test_num);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            feature1 = 4'd6;
            feature2 = 4'd4;
            feature3 = 4'd1;
            $display("Test Case %0d: Boundary feature1=6, feature2=4 (Class 1)", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            feature1 = 4'd6;
            feature2 = 4'd3;
            feature3 = 4'd1;
            $display("Test Case %0d: Boundary feature1=6, feature2=3 (Class 2)", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            feature1 = 4'd5;
            feature2 = 4'd10;
            feature3 = 4'd1;
            $display("Test Case %0d: Boundary feature1=5, feature3=1 (Class 3)", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            feature1 = 4'd0;
            feature2 = 4'd10;
            feature3 = 4'd0;
            $display("Test Case %0d: feature1=0, feature3=0 (Class 4)", test_num);
            #1;

            check_outputs(2'b11);
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
        input [1:0] expected_class_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_class_out === (expected_class_out ^ class_out ^ expected_class_out)) begin
                $display("PASS");
                $display("  Outputs: class_out=%h",
                         class_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: class_out=%h",
                         expected_class_out);
                $display("  Got:      class_out=%h",
                         class_out);
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
