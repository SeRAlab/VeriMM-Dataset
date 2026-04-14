`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] i;
    wire [3:0] o0;
    wire [3:0] o1;
    wire [3:0] o2;
    wire [3:0] o3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i(i),
        .o0(o0),
        .o1(o1),
        .o2(o2),
        .o3(o3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros", test_num);
            i = 16'h0000;
            #1;

            check_outputs(4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Ones", test_num);
            i = 16'hFFFF;
            #1;

            check_outputs(4'hF, 4'hF, 4'hF, 4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sequential Nibbles 1234", test_num);
            i = 16'h1234;

            #1;


            check_outputs(4'h4, 4'h3, 4'h2, 4'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sequential Nibbles ABCD", test_num);
            i = 16'hABCD;

            #1;


            check_outputs(4'hD, 4'hC, 4'hB, 4'hA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Pattern 5A69", test_num);
            i = 16'h5A69;

            #1;


            check_outputs(4'h9, 4'h6, 4'hA, 4'h5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Pattern F00F", test_num);
            i = 16'hF00F;

            #1;


            check_outputs(4'hF, 4'h0, 4'h0, 4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Pattern 0FF0", test_num);
            i = 16'h0FF0;

            #1;


            check_outputs(4'h0, 4'hF, 4'hF, 4'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bits Pattern AAAA", test_num);
            i = 16'hAAAA;

            #1;


            check_outputs(4'hA, 4'hA, 4'hA, 4'hA);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bits Pattern 5555", test_num);
            i = 16'h5555;

            #1;


            check_outputs(4'h5, 4'h5, 4'h5, 4'h5);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Walking Bit Pattern 8421", test_num);
            i = 16'h8421;

            #1;


            check_outputs(4'h1, 4'h2, 4'h4, 4'h8);
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
        input [3:0] expected_o0;
        input [3:0] expected_o1;
        input [3:0] expected_o2;
        input [3:0] expected_o3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o0 === (expected_o0 ^ o0 ^ expected_o0) &&
                expected_o1 === (expected_o1 ^ o1 ^ expected_o1) &&
                expected_o2 === (expected_o2 ^ o2 ^ expected_o2) &&
                expected_o3 === (expected_o3 ^ o3 ^ expected_o3)) begin
                $display("PASS");
                $display("  Outputs: o0=%h, o1=%h, o2=%h, o3=%h",
                         o0, o1, o2, o3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o0=%h, o1=%h, o2=%h, o3=%h",
                         expected_o0, expected_o1, expected_o2, expected_o3);
                $display("  Got:      o0=%h, o1=%h, o2=%h, o3=%h",
                         o0, o1, o2, o3);
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
