`timescale 1ns/1ps

module decision_tree_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] feature1;
    reg [3:0] feature2;
    wire [1:0] class;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decision_tree dut (
        .feature1(feature1),
        .feature2(feature2),
        .class(class)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Lower boundary check (feature1=0, feature2=0) -> Class 0", test_num);
        feature1 = 4'd0;
        feature2 = 4'd0;
        #1;

        check_outputs(2'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Upper boundary check for Class 0 (feature1=5, feature2=5) -> Class 0", test_num);
        feature1 = 4'd5;
        feature2 = 4'd5;
        #1;

        check_outputs(2'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Class 1 boundary (feature1=5, feature2=6) -> Class 1", test_num);
        feature1 = 4'd5;
        feature2 = 4'd6;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Class 1 max range (feature1=0, feature2=15) -> Class 1", test_num);
        feature1 = 4'd0;
        feature2 = 4'd15;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Class 2 boundary (feature1=6, feature2=5) -> Class 2", test_num);
        feature1 = 4'd6;
        feature2 = 4'd5;
        #1;

        check_outputs(2'd10);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Class 2 max range (feature1=15, feature2=0) -> Class 2", test_num);
        feature1 = 4'd15;
        feature2 = 4'd0;
        #1;

        check_outputs(2'd10);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Class 3 boundary (feature1=6, feature2=6) -> Class 3", test_num);
        feature1 = 4'd6;
        feature2 = 4'd6;
        #1;

        check_outputs(2'd11);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Class 3 max range (feature1=15, feature2=15) -> Class 3", test_num);
        feature1 = 4'd15;
        feature2 = 4'd15;
        #1;

        check_outputs(2'd11);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Random sample (feature1=3, feature2=8) -> Class 1", test_num);
        feature1 = 4'd3;
        feature2 = 4'd8;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Random sample (feature1=10, feature2=2) -> Class 2", test_num);
        feature1 = 4'd10;
        feature2 = 4'd2;
        #1;

        check_outputs(2'd2);
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
        input [1:0] expected_class;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_class === (expected_class ^ class ^ expected_class)) begin
                $display("PASS");
                $display("  Outputs: class=%h",
                         class);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: class=%h",
                         expected_class);
                $display("  Got:      class=%h",
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
