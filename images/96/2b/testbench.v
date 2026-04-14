`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [12:0] a;
    reg [12:0] b;
    reg [4:0] op;
    wire [12:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .op(op),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 13'sd500;
            b = 13'sd250;
            op = 5'd0;
            #1;

            check_outputs(13'sd750);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = -13'sd1000;
            b = 13'sd400;
            op = 5'd0;
            #1;

            check_outputs(-13'sd600);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 13'sd1000;
            b = 13'sd1200;
            op = 5'd1;
            #1;

            check_outputs(-13'sd200);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = -13'sd50;
            b = -13'sd100;
            op = 5'd1;
            #1;

            check_outputs(13'sd50);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 13'h1F0F;
            b = 13'h0FF0;
            op = 5'd2;
            #1;

            check_outputs(13'h1F0F & 13'h0FF0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 13'h1555;
            b = 13'h0AAA;
            op = 5'd3;
            #1;

            check_outputs(13'h1555 | 13'h0AAA);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 13'h1FFF;
            b = 13'h1010;
            op = 5'd4;
            #1;

            check_outputs(13'h1FFF ^ 13'h1010);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 13'h0001;
            b = 13'd5;
            op = 5'd5;
            #1;

            check_outputs(13'h0020);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 13'h1000;
            b = 13'd4;
            op = 5'd6;
            #1;

            check_outputs(13'h1000 >> 4);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = 13'sd123;
            b = 13'sd456;
            op = 5'd31;
            #1;

            check_outputs(13'd0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            a = 13'sd4095;
            b = 13'sd1;
            op = 5'd0;

            #1;


            check_outputs(13'h1000);
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
        testcase011();
        
        
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
        input [12:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
