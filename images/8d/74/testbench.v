`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire greater;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .greater(greater)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            a = 4'd0;
            b = 4'd0;
            $display("Testcase %0d: a=%0d, b=%0d (Equal)", test_num, a, b);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            a = 4'd15;
            b = 4'd0;
            $display("Testcase %0d: a=%0d, b=%0d (A > B Max/Min)", test_num, a, b);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            a = 4'd0;
            b = 4'd15;
            $display("Testcase %0d: a=%0d, b=%0d (A < B Min/Max)", test_num, a, b);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a = 4'd15;
            b = 4'd15;
            $display("Testcase %0d: a=%0d, b=%0d (Equal Max)", test_num, a, b);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            a = 4'd8;
            b = 4'd7;
            $display("Testcase %0d: a=%0d, b=%0d (A > B by 1)", test_num, a, b);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            a = 4'd7;
            b = 4'd8;
            $display("Testcase %0d: a=%0d, b=%0d (A < B by 1)", test_num, a, b);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            a = 4'd10;
            b = 4'd5;
            $display("Testcase %0d: a=%0d, b=%0d (General case A > B)", test_num, a, b);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            a = 4'd3;
            b = 4'd12;
            $display("Testcase %0d: a=%0d, b=%0d (General case A < B)", test_num, a, b);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            a = 4'd1;
            b = 4'd1;
            $display("Testcase %0d: a=%0d, b=%0d (Small Equal)", test_num, a, b);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            a = 4'd14;
            b = 4'd15;
            $display("Testcase %0d: a=%0d, b=%0d (A < B near limit)", test_num, a, b);
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
        $display("top_module Testbench");
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
        input expected_greater;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_greater === (expected_greater ^ greater ^ expected_greater)) begin
                $display("PASS");
                $display("  Outputs: greater=%b",
                         greater);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: greater=%b",
                         expected_greater);
                $display("  Got:      greater=%b",
                         greater);
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
