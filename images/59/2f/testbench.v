`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in0;
    reg [7:0] in1;
    reg [7:0] in2;
    reg [7:0] in3;
    reg sel0;
    reg sel1;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .sel0(sel0),
        .sel1(sel1),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select in0 (sel1=0, sel0=0)", test_num);
            in0 = 8'hAA;
            in1 = 8'hBB;
            in2 = 8'hCC;
            in3 = 8'hDD;
            sel1 = 0;
            sel0 = 0;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select in1 (sel1=0, sel0=1)", test_num);
            in0 = 8'hAA;
            in1 = 8'hBB;
            in2 = 8'hCC;
            in3 = 8'hDD;
            sel1 = 0;
            sel0 = 1;
            #1;

            check_outputs(8'hBB);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Select in2 (sel1=1, sel0=0)", test_num);
            in0 = 8'hAA;
            in1 = 8'hBB;
            in2 = 8'hCC;
            in3 = 8'hDD;
            sel1 = 1;
            sel0 = 0;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Select in3 (sel1=1, sel0=1)", test_num);
            in0 = 8'hAA;
            in1 = 8'hBB;
            in2 = 8'hCC;
            in3 = 8'hDD;
            sel1 = 1;
            sel0 = 1;
            #1;

            check_outputs(8'hDD);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: All inputs same value", test_num);
            in0 = 8'hFF;
            in1 = 8'hFF;
            in2 = 8'hFF;
            in3 = 8'hFF;
            sel1 = 1;
            sel0 = 0;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Data update on selected channel", test_num);
            in0 = 8'h00;
            in1 = 8'h11;
            in2 = 8'h22;
            in3 = 8'h33;
            sel1 = 0;
            sel0 = 1;
            #5;
            in1 = 8'hEE;
            #1;

            check_outputs(8'hEE);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Zero values", test_num);
            in0 = 8'h00;
            in1 = 8'h00;
            in2 = 8'h00;
            in3 = 8'h00;
            sel1 = 1;
            sel0 = 1;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_out;
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
