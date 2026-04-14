`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in0;
    reg [3:0] in1;
    wire [3:0] nor_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .in1(in1),
        .nor_out(nor_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All zeros", test_num);
            in0 = 4'b0000;
            in1 = 4'b0000;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: All ones", test_num);
            in0 = 4'b1111;
            in1 = 4'b1111;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Complementary inputs (All ones when ORed)", test_num);
            in0 = 4'b1010;
            in1 = 4'b0101;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Mixed bits - resulting in mixed NOR", test_num);
            in0 = 4'b0110;
            in1 = 4'b0001;

            #1;


            check_outputs(4'b1000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: One side zero, one side mixed", test_num);
            in0 = 4'b1110;
            in1 = 4'b0000;

            #1;


            check_outputs(4'b0001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Overlapping bits", test_num);
            in0 = 4'b0011;
            in1 = 4'b0110;

            #1;


            check_outputs(4'b1000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Only MSB 0", test_num);
            in0 = 4'b0101;
            in1 = 4'b0010;

            #1;


            check_outputs(4'b1000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Only LSB 1 in both", test_num);
            in0 = 4'b0001;
            in1 = 4'b0001;

            #1;


            check_outputs(4'b1110);
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
        input [3:0] expected_nor_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_nor_out === (expected_nor_out ^ nor_out ^ expected_nor_out)) begin
                $display("PASS");
                $display("  Outputs: nor_out=%h",
                         nor_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nor_out=%h",
                         expected_nor_out);
                $display("  Got:      nor_out=%h",
                         nor_out);
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
