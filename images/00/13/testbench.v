`timescale 1ns/1ps

module decision_tree_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decision_tree dut (
        .A(A),
        .B(B),
        .C(C),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: A > 5 (A=10, B=0, C=0)", test_num);
            A = 4'd10; B = 4'd0; C = 4'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: A <= 5 and B > 3 (A=5, B=4, C=0)", test_num);
            A = 4'd5; B = 4'd4; C = 4'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: A <= 5, B <= 3, C > 2 (A=2, B=2, C=3)", test_num);
            A = 4'd2; B = 4'd2; C = 4'd3;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Otherwise case (A=0, B=0, C=0)", test_num);
            A = 4'd0; B = 4'd0; C = 4'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary A=6 (A > 5)", test_num);
            A = 4'd6; B = 4'd0; C = 4'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary A=5, B=4 (A <= 5, B > 3)", test_num);
            A = 4'd5; B = 4'd4; C = 4'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary A=5, B=3, C=3 (A <= 5, B <= 3, C > 2)", test_num);
            A = 4'd5; B = 4'd3; C = 4'd3;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary failure (A=5, B=3, C=2)", test_num);
            A = 4'd5; B = 4'd3; C = 4'd2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max values check (A=15, B=15, C=15)", test_num);
            A = 4'd15; B = 4'd15; C = 4'd15;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fail condition (A=0, B=3, C=2)", test_num);
            A = 4'd0; B = 4'd3; C = 4'd2;
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
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
                         Y);
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
