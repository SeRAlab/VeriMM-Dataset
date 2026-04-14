`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cfi;
    reg [1:0] func;
    reg ofi;
    reg word_op;
    reg [15:0] x;
    reg [4:0] y;
    wire cfo;
    wire ofo;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cfi(cfi),
        .func(func),
        .ofi(ofi),
        .word_op(word_op),
        .x(x),
        .y(y),
        .cfo(cfo),
        .ofo(ofo),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            cfi = 1'b1; ofi = 1'b0; word_op = 1'b0; func = 2'b00;
            x = 16'hABCD; y = 5'd10;
            #1;

            check_outputs(1'b1, 1'b0, 16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            cfi = 1'b0; ofi = 1'b0; word_op = 1'b0; func = 2'b01;
            x = 16'h0001; y = 5'd4;
            #1;

            check_outputs(1'b0, 1'b0, 16'h0010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            cfi = 1'b0; ofi = 1'b0; word_op = 1'b0; func = 2'b01;
            x = 16'h8000; y = 5'd1;
            #1;

            check_outputs(1'b1, 1'b1, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            cfi = 1'b0; ofi = 1'b0; word_op = 1'b0; func = 2'b10;
            x = 16'h4000; y = 5'd2;
            #1;

            check_outputs(1'b0, 1'b0, 16'h1000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            cfi = 1'b0; ofi = 1'b0; word_op = 1'b0; func = 2'b10;
            x = 16'h8000; y = 5'd1;
            #1;

            check_outputs(1'b0, 1'b0, 16'hC000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            cfi = 1'b0; ofi = 1'b0; word_op = 1'b1; func = 2'b01;
            x = 16'hFF80; y = 5'd1;


            #1;



            check_outputs(1'b1, 1'b1, 16'hFF00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            cfi = 1'b0; ofi = 1'b0; word_op = 1'b1; func = 2'b10;
            x = 16'h0080; y = 5'd1;
            #1;

            check_outputs(1'b0, 1'b0, 16'h00C0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            cfi = 1'b1; ofi = 1'b0; word_op = 1'b0; func = 2'b01;
            x = 16'h1234; y = 5'd0;
            #1;

            check_outputs(1'b1, 1'b0, 16'h1234);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            cfi = 1'b0; ofi = 1'b0; word_op = 1'b0; func = 2'b01;
            x = 16'h0001; y = 5'd15;
            #1;

            check_outputs(1'b0, 1'b1, 16'h8000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            cfi = 1'b0; ofi = 1'b0; word_op = 1'b0; func = 2'b01;
            x = 16'hFFFF; y = 5'd16;
            #1;

            check_outputs(1'b1, 1'b1, 16'h0000);
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
        input expected_cfo;
        input expected_ofo;
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cfo === (expected_cfo ^ cfo ^ expected_cfo) &&
                expected_ofo === (expected_ofo ^ ofo ^ expected_ofo) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: cfo=%b, ofo=%b, out=%h",
                         cfo, ofo, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cfo=%b, ofo=%b, out=%h",
                         expected_cfo, expected_ofo, expected_out);
                $display("  Got:      cfo=%b, ofo=%b, out=%h",
                         cfo, ofo, out);
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
