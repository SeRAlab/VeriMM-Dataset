`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] in;
    wire [8:0] out_and;
    wire [8:0] out_or;
    wire [9:0] out_xnor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_and(out_and),
        .out_or(out_or),
        .out_xnor(out_xnor)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            in = 10'b00_0000_0000;
            $display("\nTestcase %0d: All Zeros", test_num);



            #1;




            check_outputs(9'h000, 9'h000, 10'h3FF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            in = 10'b11_1111_1111;
            $display("\nTestcase %0d: All Ones", test_num);



            #1;




            check_outputs(9'h1FF, 9'h1FF, 10'h3FF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            in = 10'b10_1010_1010;
            $display("\nTestcase %0d: Alternating 1010", test_num);



            #1;




            check_outputs(9'h000, 9'h1FF, 10'h000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            in = 10'b01_0101_0101;
            $display("\nTestcase %0d: Alternating 0101", test_num);



            #1;




            check_outputs(9'h000, 9'h1FF, 10'h000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            in = 10'b00_0000_0011;
            $display("\nTestcase %0d: Bits 0 and 1 high", test_num);



            #1;




            check_outputs(9'h001, 9'h003, 10'h1FD);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            in = 10'b10_0000_0001;
            $display("\nTestcase %0d: Boundary wrap check", test_num);



            #1;




            check_outputs(9'h000, 9'h101, 10'h2FE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            in = 10'h330;
            $display("\nTestcase %0d: Sparse blocks", test_num);



            #1;




            check_outputs(9'h110, 9'h1B8, 10'h157);
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
        input [8:0] expected_out_and;
        input [8:0] expected_out_or;
        input [9:0] expected_out_xnor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_or === (expected_out_or ^ out_or ^ expected_out_or) &&
                expected_out_xnor === (expected_out_xnor ^ out_xnor ^ expected_out_xnor)) begin
                $display("PASS");
                $display("  Outputs: out_and=%h, out_or=%h, out_xnor=%h",
                         out_and, out_or, out_xnor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and=%h, out_or=%h, out_xnor=%h",
                         expected_out_and, expected_out_or, expected_out_xnor);
                $display("  Got:      out_and=%h, out_or=%h, out_xnor=%h",
                         out_and, out_or, out_xnor);
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
