`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] in;
    wire [4:0] out_and;
    wire [4:0] out_or;
    wire [5:0] out_xor;

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
            in = 6'b000000;
            #1;

            check_outputs(5'h00, 5'h00, 6'h00);
        end
        endtask

    task testcase002;

        begin
            in = 6'b111111;
            #1;

            check_outputs(5'h1f, 5'h1f, 6'h00);
        end
        endtask

    task testcase003;

        begin
            in = 6'b101010;



            #1;




            check_outputs(5'h00, 5'h1f, 6'h3f);
        end
        endtask

    task testcase004;

        begin
            in = 6'b011001;



            #1;




            check_outputs(5'h08, 5'h1d, 6'h2d);
        end
        endtask

    task testcase005;

        begin
            in = 6'b110011;
            #1;

            check_outputs(5'h11, 5'h1b, 6'h0a);
        end
        endtask

    task testcase006;

        begin
            in = 6'b111000;
            #1;

            check_outputs(5'h18, 5'h1c, 6'h24);
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
        input [4:0] expected_out_and;
        input [4:0] expected_out_or;
        input [5:0] expected_out_xor;
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
