`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire [7:0] add;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .add(add)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 0 + 0", test_num);
            a = 4'sb0000;
            b = 4'sb0000;
            #1;

            check_outputs(8'sb00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 3 + 2", test_num);
            a = 4'sb0011;
            b = 4'sb0010;
            #1;

            check_outputs(8'sb00000101);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: -1 + -1", test_num);
            a = 4'sb1111;
            b = 4'sb1111;
            #1;

            check_outputs(8'sb11111110);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 7 + 7 (Max Positive Sum)", test_num);
            a = 4'sb0111;
            b = 4'sb0111;
            #1;

            check_outputs(8'sb00001110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: -8 + -8 (Min Negative Sum)", test_num);
            a = 4'sb1000;
            b = 4'sb1000;
            #1;

            check_outputs(8'sb11110000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 7 + -8", test_num);
            a = 4'sb0111;
            b = 4'sb1000;
            #1;

            check_outputs(8'sb11111111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: -5 + 5", test_num);
            a = 4'sb1011;
            b = 4'sb0101;
            #1;

            check_outputs(8'sb00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: -8 + 1", test_num);
            a = 4'sb1000;
            b = 4'sb0001;
            #1;

            check_outputs(8'sb11111001);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 4 + -2", test_num);
            a = 4'sb0100;
            b = 4'sb1110;
            #1;

            check_outputs(8'sb00000010);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: -1 + 0", test_num);
            a = 4'sb1111;
            b = 4'sb0000;
            #1;

            check_outputs(8'sb11111111);
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
        input [7:0] expected_add;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_add === (expected_add ^ add ^ expected_add)) begin
                $display("PASS");
                $display("  Outputs: add=%h",
                         add);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: add=%h",
                         expected_add);
                $display("  Got:      add=%h",
                         add);
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
