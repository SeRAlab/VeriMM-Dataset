`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            in = 8'd0;
            $display("Test Case %0d: Input = %d (Zero Check)", test_num, in);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in = 8'd7;
            $display("Test Case %0d: Input = %d (Single Digit)", test_num, in);
            #1;

            check_outputs(8'h07);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in = 8'd9;
            $display("Test Case %0d: Input = %d (Boundary Single Digit)", test_num, in);
            #1;

            check_outputs(8'h09);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in = 8'd10;
            $display("Test Case %0d: Input = %d (Transition to Tens)", test_num, in);
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in = 8'd25;
            $display("Test Case %0d: Input = %d", test_num, in);
            #1;

            check_outputs(8'h25);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in = 8'd40;
            $display("Test Case %0d: Input = %d (Tens Multiple)", test_num, in);
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in = 8'd68;
            $display("Test Case %0d: Input = %d", test_num, in);
            #1;

            check_outputs(8'h68);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in = 8'd83;
            $display("Test Case %0d: Input = %d", test_num, in);
            #1;

            check_outputs(8'h83);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            in = 8'd99;
            $display("Test Case %0d: Input = %d (Max valid 2-digit BCD)", test_num, in);
            #1;

            check_outputs(8'h99);
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
