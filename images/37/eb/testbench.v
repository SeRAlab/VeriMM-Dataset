`timescale 1ns/1ps

module logistic_regression_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x1;
    reg [7:0] x2;
    reg [7:0] x3;
    reg [7:0] x4;
    reg [7:0] x5;
    wire class_label;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    logistic_regression dut (
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .x4(x4),
        .x5(x5),
        .class_label(class_label)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: All inputs zero (z = -10)", test_num);
        x1 = 8'd0; x2 = 8'd0; x3 = 8'd0; x4 = 8'd0; x5 = 8'd0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: x1 at threshold (1*10 - 10 = 0)", test_num);
        x1 = 8'd10; x2 = 8'd0; x3 = 8'd0; x4 = 8'd0; x5 = 8'd0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: x1 just below threshold (1*9 - 10 = -1)", test_num);
        x1 = 8'd9; x2 = 8'd0; x3 = 8'd0; x4 = 8'd0; x5 = 8'd0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: x2 at threshold (2*5 - 10 = 0)", test_num);
        x1 = 8'd0; x2 = 8'd5; x3 = 8'd0; x4 = 8'd0; x5 = 8'd0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: x5 at threshold (5*2 - 10 = 0)", test_num);
        x1 = 8'd0; x2 = 8'd0; x3 = 8'd0; x4 = 8'd0; x5 = 8'd2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: x5 below threshold (5*1 - 10 = -5)", test_num);
        x1 = 8'd0; x2 = 8'd0; x3 = 8'd0; x4 = 8'd0; x5 = 8'd1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Multiple inputs summing to threshold (1+2+3+4 - 10 = 0)", test_num);
        x1 = 8'd1; x2 = 8'd1; x3 = 8'd1; x4 = 8'd1; x5 = 8'd0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Multiple inputs below threshold (1+2+3 - 10 = -4)", test_num);
        x1 = 8'd1; x2 = 8'd1; x3 = 8'd1; x4 = 8'd0; x5 = 8'd0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Small positive features (1+2+3+4+5 - 10 = 5)", test_num);
        x1 = 8'd1; x2 = 8'd1; x3 = 8'd1; x4 = 8'd1; x5 = 8'd1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Large feature values (Max saturation)", test_num);
        x1 = 8'd255; x2 = 8'd255; x3 = 8'd255; x4 = 8'd255; x5 = 8'd255;
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
        $display("logistic_regression Testbench");
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
        input expected_class_label;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_class_label === (expected_class_label ^ class_label ^ expected_class_label)) begin
                $display("PASS");
                $display("  Outputs: class_label=%b",
                         class_label);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: class_label=%b",
                         expected_class_label);
                $display("  Got:      class_label=%b",
                         class_label);
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
