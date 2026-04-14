`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    reg [15:0] in;
    wire [23:0] final_out;
    wire [7:0] out_hi;
    wire [7:0] out_lo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .in(in),
        .final_out(final_out),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        a = 0; b = 0; c = 0; in = 16'h0000;
        #1;

        check_outputs(24'h000000, 8'h00, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        a = 1; b = 1; c = 1; in = 16'h0000;
        #1;

        check_outputs(24'h000003, 8'h00, 8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        a = 0; b = 0; c = 0; in = 16'h00FF;
        #1;

        check_outputs(24'h0000FF, 8'h00, 8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        a = 0; b = 0; c = 0; in = 16'hFF00;
        #1;

        check_outputs(24'h0000FF, 8'hFF, 8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        a = 1; b = 0; c = 0; in = 16'h1020;

        #1;


        check_outputs(24'h000031, 8'h10, 8'h20);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        a = 1; b = 1; c = 1; in = 16'hFFFF;

        #1;


        check_outputs(24'h000201, 8'hFF, 8'hFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        a = 0; b = 1; c = 0; in = 16'hA55A;

        #1;


        check_outputs(24'h000100, 8'hA5, 8'h5A);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        a = 1; b = 1; c = 0; in = 16'h1234;

        #1;


        check_outputs(24'h000048, 8'h12, 8'h34);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        a = 0; b = 1; c = 1; in = 16'h8080;

        #1;


        check_outputs(24'h000102, 8'h80, 8'h80);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        a = 1; b = 0; c = 1; in = 16'hFE01;

        #1;


        check_outputs(24'h000101, 8'hFE, 8'h01);
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
        input [23:0] expected_final_out;
        input [7:0] expected_out_hi;
        input [7:0] expected_out_lo;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_final_out === (expected_final_out ^ final_out ^ expected_final_out) &&
                expected_out_hi === (expected_out_hi ^ out_hi ^ expected_out_hi) &&
                expected_out_lo === (expected_out_lo ^ out_lo ^ expected_out_lo)) begin
                $display("PASS");
                $display("  Outputs: final_out=%h, out_hi=%h, out_lo=%h",
                         final_out, out_hi, out_lo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_out=%h, out_hi=%h, out_lo=%h",
                         expected_final_out, expected_out_hi, expected_out_lo);
                $display("  Got:      final_out=%h, out_hi=%h, out_lo=%h",
                         final_out, out_hi, out_lo);
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
