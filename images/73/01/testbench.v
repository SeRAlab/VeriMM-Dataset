`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg en;
    wire [3:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .en(en),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 4'd5;
            b = 4'd3;
            en = 1'b0;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 4'd10;
            b = 4'd4;
            en = 1'b1;
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 4'd12;
            b = 4'd7;
            en = 1'b0;
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 4'd2;
            b = 4'd5;
            en = 1'b1;
            #1;

            check_outputs(4'd13);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 4'hf;
            b = 4'h1;
            en = 1'b0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 4'h0;
            b = 4'h1;
            en = 1'b1;
            #1;

            check_outputs(4'hf);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 4'h8;
            b = 4'h8;
            en = 1'b0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 4'h8;
            b = 4'h8;
            en = 1'b1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 4'hF;
            b = 4'hF;
            en = 1'b0;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = 4'hF;
            b = 4'hF;
            en = 1'b1;
            #1;

            check_outputs(4'h0);
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
        input [3:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
