`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in1;
    reg [31:0] in2;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero multiplication (0 * 0)", test_num);
            in1 = 32'h00000000;
            in2 = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small positive (100 * 200)", test_num);
            in1 = 32'd100;
            in2 = 32'd200;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Positive Squared (0x7FFFFFFF * 0x7FFFFFFF)", test_num);
            in1 = 32'h7FFFFFFF;
            in2 = 32'h7FFFFFFF;

            #1;


            check_outputs(32'h3FFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Min Negative Squared (0x80000000 * 0x80000000)", test_num);
            in1 = 32'h80000000;
            in2 = 32'h80000000;

            #1;


            check_outputs(32'h40000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Min Neg * Max Pos (0x80000000 * 0x7FFFFFFF)", test_num);
            in1 = 32'h80000000;
            in2 = 32'h7FFFFFFF;

            #1;


            check_outputs(32'hC0000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: -1 * -1", test_num);
            in1 = 32'hFFFFFFFF;
            in2 = 32'hFFFFFFFF;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: -1 * 1", test_num);
            in1 = 32'hFFFFFFFF;
            in2 = 32'h00000001;

            #1;


            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 2^16 * 2^16 = 2^32", test_num);
            in1 = 32'h00010000;
            in2 = 32'h00010000;

            #1;


            check_outputs(32'h00000001);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 2^30 * 4 = 2^32", test_num);
            in1 = 32'h40000000;
            in2 = 32'h00000004;

            #1;


            check_outputs(32'h00000001);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: -2^30 * 8 = -2^33", test_num);
            in1 = 32'hC0000000;
            in2 = 32'h00000008;

            #1;


            check_outputs(32'hFFFFFFF8);


        end
        endtask

    task testcase010_revised;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: -2^30 * 8 = -2^33", test_num);
            in1 = 32'hC0000000;
            in2 = 32'h00000008;
            #1;

            check_outputs(32'hFFFFFFF8);


        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Min Negative * 2", test_num);
            in1 = 32'h80000000;
            in2 = 32'h00000002;

            #1;


            check_outputs(32'hFFFFFFFF);
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
        testcase010_revised();
        testcase011();
        
        
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
