`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    wire [8:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .y(y)
    );
    task testcase001;

        begin
            a = 4'd3;
            b = 4'd7;
            c = 4'd0;

            #1;


            check_outputs(9'h060);
        end
        endtask

    task testcase002;

        begin
            a = 4'd1;
            b = 4'd2;
            c = 4'd2;

            #1;


            check_outputs(9'h080);
        end
        endtask

    task testcase003;

        begin
            a = 4'd10;
            b = 4'd5;
            c = 4'd0;

            #1;


            check_outputs(9'h0A0);
        end
        endtask

    task testcase004;

        begin
            a = 4'd15;
            b = 4'd2;
            c = 4'd3;

            #1;


            check_outputs(9'h100);
        end
        endtask

    task testcase005;

        begin
            a = 4'd12;
            b = 4'd12;
            c = 4'd7;

            #1;


            check_outputs(9'h00C);
        end
        endtask

    task testcase006;

        begin
            a = 4'b1010;
            b = 4'b1010;
            c = 4'd0;
            #1;

            check_outputs(9'h00A);
        end
        endtask

    task testcase007;

        begin
            a = 4'd1;
            b = 4'd15;
            c = 4'd9;
            #1;

            check_outputs(9'h000);
        end
        endtask

    task testcase008;

        begin
            a = 4'd5;
            b = 4'd0;
            c = 4'd1;

            #1;


            check_outputs(9'h000);
        end
        endtask

    task testcase009;

        begin
            a = 4'd15;
            b = 4'd15;
            a = 4'd1;
            b = 4'd2;
            c = 4'd15;
            #1;

            check_outputs(9'h000);
        end
        endtask

    task testcase010;

        begin
            a = 4'd8;
            b = 4'd7;
            c = 4'd1;

            #1;


            check_outputs(9'h1C0);
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
        input [8:0] expected_y;
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
