`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] in_0;
    reg [1:0] in_1;
    wire [1:0] out;

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
            test_num = 1;
            in_0 = 2'b00;
            in_1 = 2'b00;
            $display("Test %0d: Equality (00 vs 00)", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in_0 = 2'b11;
            in_1 = 2'b11;
            $display("Test %0d: Equality (11 vs 11)", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in_0 = 2'b01;
            in_1 = 2'b00;
            $display("Test %0d: Greater Than (01 vs 00)", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in_0 = 2'b11;
            in_1 = 2'b01;
            $display("Test %0d: Greater Than (11 vs 01)", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in_0 = 2'b00;
            in_1 = 2'b01;
            $display("Test %0d: Less Than (00 vs 01)", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in_0 = 2'b01;
            in_1 = 2'b10;
            $display("Test %0d: Less Than (01 vs 10)", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in_0 = 2'b11;
            in_1 = 2'b00;
            $display("Test %0d: Greater Than Max vs Min (11 vs 00)", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in_0 = 2'b00;
            in_1 = 2'b11;
            $display("Test %0d: Less Than Min vs Max (00 vs 11)", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            in_0 = 2'b10;
            in_1 = 2'b10;
            $display("Test %0d: Equality Mid (10 vs 10)", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            in_0 = 2'b10;
            in_1 = 2'b01;
            $display("Test %0d: Greater Than Mid (10 vs 01)", test_num);
            #1;

            check_outputs(2'b01);
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
        input [1:0] expected_out;
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
