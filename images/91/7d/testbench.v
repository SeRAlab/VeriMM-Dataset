`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [19:0] in;
    wire [18:0] out_and;
    wire [18:0] out_or;
    wire [19:0] out_xnor;

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
            test_num = 1;
            in = 20'h00000;

            #1;


            check_outputs(19'h00000, 19'h00000, 20'hFFFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in = 20'hFFFFF;

            #1;


            check_outputs(19'h7FFFF, 19'h7FFFF, 20'hFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in = 20'hAAAAA;



            #1;




            check_outputs(19'h00000, 19'h7FFFF, 20'h00000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in = 20'h55555;
            #1;

            check_outputs(19'h00000, 19'h7FFFF, 20'h00000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in = 20'hF000F;



            #1;




            check_outputs(19'h70007, 19'h7801F, 20'hF7FF7);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in = 20'h00003;



            #1;




            check_outputs(19'h00001, 19'h00003, 20'h7FFFD);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in = 20'h80001;



            #1;




            check_outputs(19'h00000, 19'h40001, 20'hBFFFE);
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
        input [18:0] expected_out_and;
        input [18:0] expected_out_or;
        input [19:0] expected_out_xnor;
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
