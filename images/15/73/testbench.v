`timescale 1ns/1ps

module svm_classifier_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x;
    reg [7:0] y;
    wire class;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    svm_classifier dut (
        .x(x),
        .y(y),
        .class(class)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Point (10, 20) - Above boundary", test_num);
        x = 8'd10;
        y = 8'd20;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Point (20, 10) - Below boundary", test_num);
        x = 8'd20;
        y = 8'd10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Point (50, 50) - Exactly on boundary", test_num);
        x = 8'd50;
        y = 8'd50;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Origin (0, 0)", test_num);
        x = 8'd0;
        y = 8'd0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Max values (255, 255)", test_num);
        x = 8'd255;
        y = 8'd255;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Extreme Y (0, 255)", test_num);
        x = 8'd0;
        y = 8'd255;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: Extreme X (255, 0)", test_num);
        x = 8'd255;
        y = 8'd0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTestcase %0d: Close boundary - Class 1 side", test_num);
        x = 8'd128;
        y = 8'd129;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTestcase %0d: Close boundary - Class 0 side", test_num);
        x = 8'd128;
        y = 8'd127;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("\nTestcase %0d: Mid-range classification", test_num);
        x = 8'd100;
        y = 8'd150;
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
        input expected_class;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_class === (expected_class ^ class ^ expected_class)) begin
                $display("PASS");
                $display("  Outputs: class=%b",
                         class);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: class=%b",
                         expected_class);
                $display("  Got:      class=%b",
                         class);
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
