`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] in;
    wire [8:0] out_even;
    wire [9:0] out_flip;
    wire [8:0] out_odd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_even(out_even),
        .out_flip(out_flip),
        .out_odd(out_odd)
    );
    task testcase001;

        begin
            test_num = 1;
            in = 10'h000;
            #1;

            check_outputs(9'h1FE, 10'h000, 9'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in = 10'h3FF;
            #1;

            check_outputs(9'h000, 10'h000, 9'h1FF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in = 10'h2AA;
            #1;

            check_outputs(9'h000, 10'h3FF, 9'h000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in = 10'h155;
            #1;

            check_outputs(9'h000, 10'h3FF, 9'h000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in = 10'h333;
            #1;

            check_outputs(9'h088, 10'h0AA, 9'h111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in = 10'h0CC;
            #1;

            check_outputs(9'h022, 10'h0AA, 9'h044);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in = 10'h3E0;
            #1;

            check_outputs(9'h01E, 10'h210, 9'h1E0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in = 10'h38E;
            #1;

            check_outputs(9'h0E0, 10'h249, 9'h186);
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
        input [8:0] expected_out_even;
        input [9:0] expected_out_flip;
        input [8:0] expected_out_odd;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_even === (expected_out_even ^ out_even ^ expected_out_even) &&
                expected_out_flip === (expected_out_flip ^ out_flip ^ expected_out_flip) &&
                expected_out_odd === (expected_out_odd ^ out_odd ^ expected_out_odd)) begin
                $display("PASS");
                $display("  Outputs: out_even=%h, out_flip=%h, out_odd=%h",
                         out_even, out_flip, out_odd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_even=%h, out_flip=%h, out_odd=%h",
                         expected_out_even, expected_out_flip, expected_out_odd);
                $display("  Got:      out_even=%h, out_flip=%h, out_odd=%h",
                         out_even, out_flip, out_odd);
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
