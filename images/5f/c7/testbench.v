`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg direction;
    reg [7:0] in;
    reg [2:0] shift;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .direction(direction),
        .in(in),
        .shift(shift),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            direction = 0;
            in = 8'hAA;
            shift = 3'd0;
            $display("Test %0d: Left shift by 0 (in=8'hAA, shift=0)", test_num);
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            direction = 1;
            in = 8'h55;
            shift = 3'd0;
            $display("Test %0d: Right shift by 0 (in=8'h55, shift=0)", test_num);
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            direction = 0;
            in = 8'h01;
            shift = 3'd1;
            $display("Test %0d: Left shift by 1 (in=8'h01, shift=1)", test_num);
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            direction = 1;
            in = 8'h80;
            shift = 3'd1;
            $display("Test %0d: Right shift by 1 (in=8'h80, shift=1)", test_num);
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            direction = 0;
            in = 8'h0F;
            shift = 3'd4;
            $display("Test %0d: Left shift by 4 (in=8'h0F, shift=4)", test_num);
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            direction = 1;
            in = 8'hF0;
            shift = 3'd4;
            $display("Test %0d: Right shift by 4 (in=8'hF0, shift=4)", test_num);
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            direction = 0;
            in = 8'h01;
            shift = 3'd7;
            $display("Test %0d: Left shift by 7 (in=8'h01, shift=7)", test_num);
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            direction = 1;
            in = 8'h80;
            shift = 3'd7;
            $display("Test %0d: Right shift by 7 (in=8'h80, shift=7)", test_num);
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            direction = 0;
            in = 8'hA5;
            shift = 3'd2;
            $display("Test %0d: Left shift by 2 (in=8'hA5, shift=2)", test_num);

            #1;


            check_outputs(8'h94);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            direction = 1;
            in = 8'hA5;
            shift = 3'd2;
            $display("Test %0d: Right shift by 2 (in=8'hA5, shift=2)", test_num);

            #1;


            check_outputs(8'h29);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            direction = 0;
            in = 8'hFF;
            shift = 3'd7;
            $display("Test %0d: Left shift by 7 (in=8'hFF, shift=7)", test_num);

            #1;


            check_outputs(8'h80);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            direction = 1;
            in = 8'hFF;
            shift = 3'd7;
            $display("Test %0d: Right shift by 7 (in=8'hFF, shift=7)", test_num);

            #1;


            check_outputs(8'h01);
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
        testcase012();
        
        
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
