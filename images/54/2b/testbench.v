`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in0;
    reg [3:0] in1;
    wire [3:0] or_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .in1(in1),
        .or_out(or_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros", test_num);
            in0 = 4'b0000;
            in1 = 4'b0000;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones", test_num);
            in0 = 4'b1111;
            in1 = 4'b1111;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complementary patterns (A/5)", test_num);
            in0 = 4'b1010;
            in1 = 4'b0101;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: One input zero, one input non-zero", test_num);
            in0 = 4'b1100;
            in1 = 4'b0000;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: One input zero, other input non-zero", test_num);
            in0 = 4'b0000;
            in1 = 4'b0011;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overlapping bits", test_num);
            in0 = 4'b1101;
            in1 = 4'b1011;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Disjoint bits", test_num);
            in0 = 4'b1000;
            in1 = 4'b0001;
            #1;

            check_outputs(4'b1001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern check 1", test_num);
            in0 = 4'b0110;
            in1 = 4'b0010;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern check 2", test_num);
            in0 = 4'b0011;
            in1 = 4'b1100;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern check 3", test_num);
            in0 = 4'b1011;
            in1 = 4'b0001;
            #1;

            check_outputs(4'b1011);
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
        input [3:0] expected_or_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_or_out === (expected_or_out ^ or_out ^ expected_or_out)) begin
                $display("PASS");
                $display("  Outputs: or_out=%h",
                         or_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: or_out=%h",
                         expected_or_out);
                $display("  Got:      or_out=%h",
                         or_out);
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
