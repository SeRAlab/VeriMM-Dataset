`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in_0;
    reg [3:0] in_1;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_0(in_0),
        .in_1(in_1),
        .out(out)
    );
    task testcase001;

        begin
            $display("Testcase 001: 0 x 0");
            test_num = test_num + 1;
            in_0 = 4'd0; in_1 = 4'd0;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: 1 x 1");
            test_num = test_num + 1;
            in_0 = 4'd1; in_1 = 4'd1;

            #1;


            check_outputs(8'h81);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: 2 x 2");
            test_num = test_num + 1;
            in_0 = 4'd2; in_1 = 4'd2;

            #1;


            check_outputs(8'h84);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: 15 x 1 (Max Input x 1)");
            test_num = test_num + 1;
            in_0 = 4'd15; in_1 = 4'd1;

            #1;


            check_outputs(8'h0F);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: 15 x 15 (Max Input x Max Input)");
            test_num = test_num + 1;
            in_0 = 4'd15; in_1 = 4'd1;
            in_0 = 4'd15; in_1 = 4'd15;


            #1;



            check_outputs(8'hE1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: 10 x 10");
            test_num = test_num + 1;
            in_0 = 4'd10; in_1 = 4'd10;


            #1;



            check_outputs(8'hE4);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: 8 x 4 (Power of 2)");
            test_num = test_num + 1;
            in_0 = 4'd8; in_1 = 4'd4;


            #1;



            check_outputs(8'hA0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: 7 x 3");
            test_num = test_num + 1;
            in_0 = 4'd7; in_1 = 4'd3;


            #1;



            check_outputs(8'h95);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: 1 x 0 (Zero check)");
            test_num = test_num + 1;
            in_0 = 4'd1; in_1 = 4'd0;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: 5 x 5");
            test_num = test_num + 1;
            in_0 = 4'd5; in_1 = 4'd5;


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
        testcase010();
        
        
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
