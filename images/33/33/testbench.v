`timescale 1ns/1ps

module decision_tree_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    wire [1:0] category;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decision_tree dut (
        .A(A),
        .B(B),
        .C(C),
        .category(category)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=0, B=0, C=0 -> Category 00", test_num);
            A = 0; B = 0; C = 0;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=0, B=0, C=1 -> Category 00", test_num);
            A = 0; B = 0; C = 1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=0, B=1, C=0 -> Category 01", test_num);
            A = 0; B = 1; C = 0;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=0, B=1, C=1 -> Category 01", test_num);
            A = 0; B = 1; C = 1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=1, B=0, C=0 -> Category 10", test_num);
            A = 1; B = 0; C = 0;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=1, B=1, C=0 -> Category 10", test_num);
            A = 1; B = 1; C = 0;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=1, B=0, C=1 -> Category 11", test_num);
            A = 1; B = 0; C = 1;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=1, B=1, C=1 -> Category 11", test_num);
            A = 1; B = 1; C = 1;
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
        input [1:0] expected_category;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_category === (expected_category ^ category ^ expected_category)) begin
                $display("PASS");
                $display("  Outputs: category=%h",
                         category);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: category=%h",
                         expected_category);
                $display("  Got:      category=%h",
                         category);
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
