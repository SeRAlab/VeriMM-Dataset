`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] k;
    reg [3:0] l;
    wire [3:0] m;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .k(k),
        .l(l),
        .m(m)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive addition (2 + 3 = 5)", test_num);
            k = 4'sb0010; l = 4'sb0011;
            #1;

            check_outputs(4'sb0101);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative addition (-1 + -2 = -3)", test_num);
            k = 4'sb1111; l = 4'sb1110;
            #1;

            check_outputs(4'sb1101);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mixed sign addition (5 + -2 = 3)", test_num);
            k = 4'sb0101; l = 4'sb1110;
            #1;

            check_outputs(4'sb0011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mixed sign addition (-5 + 3 = -2)", test_num);
            k = 4'sb1011; l = 4'sb0011;
            #1;

            check_outputs(4'sb1110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero identity (-8 + 0 = -8)", test_num);
            k = 4'sb1000; l = 4'sb0000;
            #1;

            check_outputs(4'sb1000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Signed Overflow (7 + 1 = -8)", test_num);

            k = 4'sb0111; l = 4'sb0001;
            #1;

            check_outputs(4'sb1000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Signed Underflow (-8 + -1 = 7)", test_num);

            k = 4'sb1000; l = 4'sb1111;
            #1;

            check_outputs(4'sb0111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Resulting in zero (-4 + 4 = 0)", test_num);
            k = 4'sb1100; l = 4'sb0100;
            #1;

            check_outputs(4'sb0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary values (-8 + 7 = -1)", test_num);
            k = 4'sb1000; l = 4'sb0111;
            #1;

            check_outputs(4'sb1111);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Adding Max values (7 + 7 = -2 overflow)", test_num);
            k = 4'sb0111; l = 4'sb0111;
            #1;

            check_outputs(4'sb1110);
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
        input [3:0] expected_m;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_m === (expected_m ^ m ^ expected_m)) begin
                $display("PASS");
                $display("  Outputs: m=%h",
                         m);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m=%h",
                         expected_m);
                $display("  Got:      m=%h",
                         m);
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
