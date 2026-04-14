`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg en;
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
        .en(en),
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
            $display("Test %0d: Select in0 with Enable High", test_num);
            en = 1'b1;
            sel = 2'b00;
            in0 = 4'hA;
            in1 = 4'hB;
            in2 = 4'hC;
            in3 = 4'hD;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Select in1 with Enable High", test_num);
            en = 1'b1;
            sel = 2'b01;
            in0 = 4'hA;
            in1 = 4'h5;
            in2 = 4'hC;
            in3 = 4'hD;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Select in2 with Enable High", test_num);
            en = 1'b1;
            sel = 2'b10;
            in0 = 4'hA;
            in1 = 4'hB;
            in2 = 4'hF;
            in3 = 4'hD;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Select in3 with Enable High", test_num);
            en = 1'b1;
            sel = 2'b11;
            in0 = 4'hA;
            in1 = 4'hB;
            in2 = 4'hC;
            in3 = 4'h3;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Enable Low, Output should be Zero (sel=0)", test_num);
            en = 1'b0;
            sel = 2'b00;
            in0 = 4'hA;
            in1 = 4'hB;
            in2 = 4'hC;
            in3 = 4'hD;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Enable Low, Output should be Zero (sel=2)", test_num);
            en = 1'b0;
            sel = 2'b10;
            in0 = 4'hA;
            in1 = 4'hB;
            in2 = 4'hC;
            in3 = 4'hD;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: All Inputs Zero, Enable High", test_num);
            en = 1'b1;
            sel = 2'b01;
            in0 = 4'h0;
            in1 = 4'h0;
            in2 = 4'h0;
            in3 = 4'h0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Maximum Input Values (0xF)", test_num);
            en = 1'b1;
            sel = 2'b11;
            in0 = 4'hF;
            in1 = 4'hF;
            in2 = 4'hF;
            in3 = 4'hF;
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
