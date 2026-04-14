`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire [7:0] p;
    wire sign;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .p(p),
        .sign(sign)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 4'd3; b = 4'd2;
        #1;

        check_outputs(8'h06, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 4'd3; b = -4'd2;
        #1;

        check_outputs(8'hFA, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = -4'd3; b = 4'd2;
        #1;

        check_outputs(8'hFA, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = -4'd3; b = -4'd2;
        #1;

        check_outputs(8'h06, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 4'd7; b = 4'd7;
        #1;

        check_outputs(8'h31, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 4'b1000; b = 4'd7;
        #1;

        check_outputs(8'hC8, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 4'b1000; b = 4'b1000;
        #1;

        check_outputs(8'h40, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 4'd0; b = -4'd5;
        #1;

        check_outputs(8'h00, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 4'b1111; b = 4'b1111;
        #1;

        check_outputs(8'h01, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 4'b0001; b = 4'b1111;
        #1;

        check_outputs(8'hFF, 1'b1);
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
        input [7:0] expected_p;
        input expected_sign;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_p === (expected_p ^ p ^ expected_p) &&
                expected_sign === (expected_sign ^ sign ^ expected_sign)) begin
                $display("PASS");
                $display("  Outputs: p=%h, sign=%b",
                         p, sign);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%h, sign=%b",
                         expected_p, expected_sign);
                $display("  Got:      p=%h, sign=%b",
                         p, sign);
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
