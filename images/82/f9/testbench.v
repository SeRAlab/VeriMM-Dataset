`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in0;
    reg [31:0] in1;
    reg [31:0] in2;
    reg [31:0] in3;
    reg [1:0] sel;
    wire [31:0] out;

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
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select in0", test_num);
            in0 = 32'hAAAA_AAAA;
            in1 = 32'hBBBB_BBBB;
            in2 = 32'hCCCC_CCCC;
            in3 = 32'hDDDD_DDDD;
            sel = 2'b00;
            #1;

            check_outputs(in0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select in1", test_num);
            in0 = 32'h1111_1111;
            in1 = 32'h2222_2222;
            in2 = 32'h3333_3333;
            in3 = 32'h4444_4444;
            sel = 2'b01;
            #1;

            check_outputs(in1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select in2", test_num);
            in0 = 32'h5555_5555;
            in1 = 32'h6666_6666;
            in2 = 32'h7777_7777;
            in3 = 32'h8888_8888;
            sel = 2'b10;
            #1;

            check_outputs(in2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select in3", test_num);
            in0 = 32'h9999_9999;
            in1 = 32'h0000_0000;
            in2 = 32'hFFFF_FFFF;
            in3 = 32'h1234_5678;
            sel = 2'b11;
            #1;

            check_outputs(in3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Edge case - all inputs 0, select in0", test_num);
            in0 = 32'h0000_0000;
            in1 = 32'h0000_0000;
            in2 = 32'h0000_0000;
            in3 = 32'h0000_0000;
            sel = 2'b00;
            #1;

            check_outputs(in0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Edge case - all inputs F, select in3", test_num);
            in0 = 32'hFFFF_FFFF;
            in1 = 32'hFFFF_FFFF;
            in2 = 32'hFFFF_FFFF;
            in3 = 32'hFFFF_FFFF;
            sel = 2'b11;
            #1;

            check_outputs(in3);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random selection and pattern", test_num);
            in0 = 32'hDEAD_BEEF;
            in1 = 32'hCAFE_BABE;
            in2 = 32'hBAAD_F00D;
            in3 = 32'hFEED_FACE;
            sel = 2'b10;
            #1;

            check_outputs(in2);
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
