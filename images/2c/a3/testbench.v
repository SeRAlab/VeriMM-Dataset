`timescale 1ns/1ps

module decision_tree_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x1;
    reg [3:0] x2;
    wire class;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decision_tree dut (
        .x1(x1),
        .x2(x2),
        .class(class)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: x1=0, x2=0 (x1 < 5, x2 < 5)", test_num);
        x1 = 4'd0;
        x2 = 4'd0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: x1=4, x2=4 (x1 < 5, x2 < 5 - Boundary)", test_num);
        x1 = 4'd4;
        x2 = 4'd4;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: x1=0, x2=5 (x1 < 5, x2 >= 5 - Boundary)", test_num);
        x1 = 4'd0;
        x2 = 4'd5;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: x1=3, x2=15 (x1 < 5, x2 >= 5)", test_num);
        x1 = 4'd3;
        x2 = 4'd15;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: x1=5, x2=0 (x1 >= 5, x2 < 5 - Boundary)", test_num);
        x1 = 4'd5;
        x2 = 4'd0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: x1=15, x2=4 (x1 >= 5, x2 < 5)", test_num);
        x1 = 4'd15;
        x2 = 4'd4;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: x1=5, x2=5 (x1 >= 5, x2 >= 5 - Boundary)", test_num);
        x1 = 4'd5;
        x2 = 4'd5;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: x1=10, x2=10 (x1 >= 5, x2 >= 5)", test_num);
        x1 = 4'd10;
        x2 = 4'd10;
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
