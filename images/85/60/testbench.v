`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [3:0] in0;
    reg [3:0] in1;
    reg [3:0] in2;
    reg [3:0] in3;
    reg [1:0] sel;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .enable(enable),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            enable = 1'b0;
            in0 = 4'hA;
            in1 = 4'hB;
            in2 = 4'hC;
            in3 = 4'hD;
            sel = 2'b00;
            $display("Test Case %0d: Enable=0, Sel=00", test_num);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            enable = 1'b1;
            in0 = 4'h5;
            in1 = 4'h0;
            in2 = 4'h0;
            in3 = 4'h0;
            sel = 2'b00;
            $display("Test Case %0d: Enable=1, Sel=00 (in0=5)", test_num);
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            enable = 1'b1;
            in0 = 4'h0;
            in1 = 4'hE;
            in2 = 4'h0;
            in3 = 4'h0;
            sel = 2'b01;
            $display("Test Case %0d: Enable=1, Sel=01 (in1=E)", test_num);
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            enable = 1'b1;
            in0 = 4'h0;
            in1 = 4'h0;
            in2 = 4'h9;
            in3 = 4'h0;
            sel = 2'b10;
            $display("Test Case %0d: Enable=1, Sel=10 (in2=9)", test_num);
            #1;

            check_outputs(4'h9);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            enable = 1'b1;
            in0 = 4'h0;
            in1 = 4'h0;
            in2 = 4'h0;
            in3 = 4'hF;
            sel = 2'b11;
            $display("Test Case %0d: Enable=1, Sel=11 (in3=F)", test_num);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            enable = 1'b1;
            in3 = 4'h7;
            sel = 2'b11;
            #5;
            enable = 1'b0;
            $display("Test Case %0d: Switching Enable 1->0 while Sel=11", test_num);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            enable = 1'b1;
            sel = 2'b01;
            in1 = 4'h3;
            in0 = 4'hF;
            in2 = 4'hF;
            in3 = 4'hF;
            $display("Test Case %0d: Selection interference check (Sel=01, in1=3)", test_num);
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            enable = 1'b1;
            in0 = 4'hF; in1 = 4'hF; in2 = 4'hF; in3 = 4'hF;
            sel = 2'b10;
            $display("Test Case %0d: All inputs max, Sel=10", test_num);
            #1;

            check_outputs(4'hF);
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
        input [3:0] expected_out;
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
