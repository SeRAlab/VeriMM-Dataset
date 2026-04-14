`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] X;
    reg [7:0] Y;
    wire [7:0] ATTR;
    wire [7:0] CHAR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .X(X),
        .Y(Y),
        .ATTR(ATTR),
        .CHAR(CHAR)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero inputs", test_num);
            X = 8'd0;
            Y = 8'd0;


            #1;



            check_outputs(8'h00, 8'd64);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Small inputs", test_num);
            X = 8'd10;
            Y = 8'd20;


            #1;



            check_outputs(8'hA4, 8'd94);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: CHAR wrap-around check", test_num);
            X = 8'd100;
            Y = 8'd100;



            #1;




            check_outputs(8'h44, 8'd8);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max inputs", test_num);
            X = 8'hFF;
            Y = 8'hFF;


            #1;



            check_outputs(8'hFF, 8'h3E);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Specific bit patterns for ATTR", test_num);
            X = 8'h5A;
            Y = 8'h3B;


            #1;



            check_outputs(8'hAB, 8'hD5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary conditions (ATTR higher bits ignored)", test_num);
            X = 8'hF0;
            Y = 8'h0F;


            #1;



            check_outputs(8'h0F, 8'h3F);
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
        input [7:0] expected_ATTR;
        input [7:0] expected_CHAR;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ATTR === (expected_ATTR ^ ATTR ^ expected_ATTR) &&
                expected_CHAR === (expected_CHAR ^ CHAR ^ expected_CHAR)) begin
                $display("PASS");
                $display("  Outputs: ATTR=%h, CHAR=%h",
                         ATTR, CHAR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ATTR=%h, CHAR=%h",
                         expected_ATTR, expected_CHAR);
                $display("  Got:      ATTR=%h, CHAR=%h",
                         ATTR, CHAR);
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
