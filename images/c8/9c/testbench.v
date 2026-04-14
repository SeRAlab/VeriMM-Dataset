`timescale 1ns/1ps

module m1_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    wire [3:0] b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    m1 dut (
        .a(a),
        .b(b)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a = 0 (Condition: a <= 4, Expected b = 0)", test_num);
            a = 4'd0;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a = 2 (Condition: a <= 4, Expected b = 4)", test_num);
            a = 4'd2;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a = 4 (Boundary Condition: a <= 4, Expected b = 8)", test_num);
            a = 4'd4;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a = 5 (Boundary Condition: a > 4, Expected b = 2)", test_num);
            a = 4'd5;
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a = 6 (Condition: a > 4, Expected b = 3)", test_num);
            a = 4'd6;
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a = 9 (Condition: a > 4, Expected b = 4)", test_num);
            a = 4'd9;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a = 15 (Max Input, Condition: a > 4, Expected b = 7)", test_num);
            a = 4'd15;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a = 3 (Condition: a <= 4, Expected b = 6)", test_num);
            a = 4'd3;
            #1;

            check_outputs(4'd6);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("m1 Testbench");
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
        input [3:0] expected_b;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_b === (expected_b ^ b ^ expected_b)) begin
                $display("PASS");
                $display("  Outputs: b=%h",
                         b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b=%h",
                         expected_b);
                $display("  Got:      b=%h",
                         b);
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
