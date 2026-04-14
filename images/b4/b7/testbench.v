`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in0;
    reg [15:0] in1;
    reg sel;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .in1(in1),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select in0 (0000)", test_num);
            in0 = 16'h0000;
            in1 = 16'hFFFF;
            sel = 1'b0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select in1 (FFFF)", test_num);
            in0 = 16'h0000;
            in1 = 16'hFFFF;
            sel = 1'b1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select in0 (AAAA)", test_num);
            in0 = 16'hAAAA;
            in1 = 16'h5555;
            sel = 1'b0;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select in1 (5555)", test_num);
            in0 = 16'hAAAA;
            in1 = 16'h5555;
            sel = 1'b1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Select in0 (1234)", test_num);
            in0 = 16'h1234;
            in1 = 16'hABCD;
            sel = 1'b0;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Select in1 (ABCD)", test_num);
            in0 = 16'h1234;
            in1 = 16'hABCD;
            sel = 1'b1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Switching select while inputs constant", test_num);
            in0 = 16'hF0F0;
            in1 = 16'h0F0F;
            sel = 1'b0;
            #1;
            sel = 1'b1;
            #1;

            check_outputs(16'h0F0F);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Large arbitrary value on in0", test_num);
            in0 = 16'hDEAF;
            in1 = 16'hBEEF;
            sel = 1'b0;
            #1;

            check_outputs(16'hDEAF);
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
        input [15:0] expected_out;
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
