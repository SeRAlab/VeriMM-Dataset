`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire borrow;
    wire [7:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .borrow(borrow),
        .s(s)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: a=10, b=5 (Simple subtraction, no borrow)", test_num);
            a = 8'd10;
            b = 8'd5;
            #1;

            check_outputs(1'b0, 8'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: a=5, b=10 (Subtraction with borrow)", test_num);
            a = 8'd5;
            b = 8'd10;

            #1;


            check_outputs(1'b1, 8'hFB);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: a=128, b=128 (Equal values)", test_num);
            a = 8'd128;
            b = 8'd128;
            #1;

            check_outputs(1'b0, 8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: a=0, b=1 (Minimum a, small b)", test_num);
            a = 8'd0;
            b = 8'd1;

            #1;


            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: a=255, b=0 (Maximum a, minimum b)", test_num);
            a = 8'hFF;
            b = 8'h00;
            #1;

            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: a=0, b=255 (Minimum a, maximum b)", test_num);
            a = 8'h00;
            b = 8'hFF;

            #1;


            check_outputs(1'b1, 8'h01);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: a=255, b=255 (Maximum values)", test_num);
            a = 8'hFF;
            b = 8'hFF;
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: a=100, b=200 (Large numbers, borrow)", test_num);
            a = 8'd100;
            b = 8'd200;

            #1;


            check_outputs(1'b1, 8'h9C);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: a=0, b=0 (Zero values)", test_num);
            a = 8'h00;
            b = 8'h00;
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: a=1, b=0 (Small result)", test_num);
            a = 8'd1;
            b = 8'd0;
            #1;

            check_outputs(1'b0, 8'h01);
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
        input expected_borrow;
        input [7:0] expected_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_borrow === (expected_borrow ^ borrow ^ expected_borrow) &&
                expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: borrow=%b, s=%h",
                         borrow, s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: borrow=%b, s=%h",
                         expected_borrow, expected_s);
                $display("  Got:      borrow=%b, s=%h",
                         borrow, s);
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
