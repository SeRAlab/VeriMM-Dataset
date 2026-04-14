`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] in;
    wire [8:0] out_and;
    wire [8:0] out_or;
    wire [9:0] out_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_and(out_and),
        .out_or(out_or),
        .out_xor(out_xor)
    );
    task testcase001;

        begin
            in = 10'b00_0000_0000;
            #1;

            check_outputs(9'h000, 9'h000, 10'h000);
        end
        endtask

    task testcase002;

        begin
            in = 10'b11_1111_1111;
            #1;

            check_outputs(9'h1FF, 9'h1FF, 10'h000);
        end
        endtask

    task testcase003;

        begin
            in = 10'b10_1010_1010;
            #1;

            check_outputs(9'h000, 9'h1FF, 10'h3FF);
        end
        endtask

    task testcase004;

        begin
            in = 10'b01_0101_0101;
            #1;

            check_outputs(9'h000, 9'h1FF, 10'h3FF);
        end
        endtask

    task testcase005;

        begin
            in = 10'b00_0000_0011;
            #1;

            check_outputs(9'h001, 9'h003, 10'h005);
        end
        endtask

    task testcase006;

        begin
            in = 10'b11_0000_0000;
            #1;

            check_outputs(9'h100, 9'h180, 10'h101);
        end
        endtask

    task testcase007;

        begin
            in = 10'b11_0110_1101;
            #1;

            check_outputs(9'h124, 9'h1FF, 10'h1B6);
        end
        endtask

    task testcase008;

        begin
            in = 10'b00_1110_0111;
            #1;

            check_outputs(9'h063, 9'h0F7, 10'h129);
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
        input [8:0] expected_out_and;
        input [8:0] expected_out_or;
        input [9:0] expected_out_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_or === (expected_out_or ^ out_or ^ expected_out_or) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor)) begin
                $display("PASS");
                $display("  Outputs: out_and=%h, out_or=%h, out_xor=%h",
                         out_and, out_or, out_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and=%h, out_or=%h, out_xor=%h",
                         expected_out_and, expected_out_or, expected_out_xor);
                $display("  Got:      out_and=%h, out_or=%h, out_xor=%h",
                         out_and, out_or, out_xor);
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
