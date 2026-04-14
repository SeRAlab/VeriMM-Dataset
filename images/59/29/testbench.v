`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in1;
    reg [7:0] in2;
    reg [7:0] in3;
    reg [7:0] in4;
    reg sel0;
    reg sel1;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .sel0(sel0),
        .sel1(sel1),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select in1 (sel1=0, sel0=0)", test_num);
        in1 = 8'hAA; in2 = 8'h00; in3 = 8'h00; in4 = 8'h00;
        sel1 = 0; sel0 = 0;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select in2 (sel1=0, sel0=1)", test_num);
        in1 = 8'h11; in2 = 8'hBB; in3 = 8'h33; in4 = 8'h44;
        sel1 = 0; sel0 = 1;
        #1;

        check_outputs(8'hBB);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select in3 (sel1=1, sel0=0)", test_num);
        in1 = 8'hDE; in2 = 8'hAD; in3 = 8'hBE; in4 = 8'hEF;
        sel1 = 1; sel0 = 0;
        #1;

        check_outputs(8'hBE);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select in4 (sel1=1, sel0=1)", test_num);
        in1 = 8'h01; in2 = 8'h02; in3 = 8'h03; in4 = 8'hFF;
        sel1 = 1; sel0 = 1;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All inputs identical (0x55)", test_num);
        in1 = 8'h55; in2 = 8'h55; in3 = 8'h55; in4 = 8'h55;
        sel1 = 1; sel0 = 0;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Random pattern for in1", test_num);
        in1 = 8'hA5; in2 = 8'h5A; in3 = 8'hC3; in4 = 8'h3C;
        sel1 = 0; sel0 = 0;
        #1;

        check_outputs(8'hA5);
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
