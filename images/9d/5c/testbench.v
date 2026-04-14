`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a_in;
    reg [7:0] b_in;
    reg [1:0] op;
    wire [7:0] c_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a_in(a_in),
        .b_in(b_in),
        .op(op),
        .c_out(c_out)
    );
    task testcase001;

    begin
        test_num = 1;
        a_in = 8'd15;
        b_in = 8'd25;
        op = 2'b00;
        #1;

        check_outputs(8'd40);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a_in = 8'd200;
        b_in = 8'd100;
        op = 2'b00;
        #1;

        check_outputs(8'd44);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a_in = 8'd50;
        b_in = 8'd20;
        op = 2'b01;
        #1;

        check_outputs(8'd30);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a_in = 8'd10;
        b_in = 8'd20;
        op = 2'b01;
        #1;

        check_outputs(8'd246);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a_in = 8'd12;
        b_in = 8'd5;
        op = 2'b10;
        #1;

        check_outputs(8'd60);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a_in = 8'd64;
        b_in = 8'd4;
        op = 2'b10;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a_in = 8'd100;
        b_in = 8'd4;
        op = 2'b11;
        #1;

        check_outputs(8'd25);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a_in = 8'd10;
        b_in = 8'd3;
        op = 2'b11;
        #1;

        check_outputs(8'd3);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a_in = 8'd0;
        b_in = 8'd5;
        op = 2'b11;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a_in = 8'd255;
        b_in = 8'd255;
        op = 2'b00;
        #1;

        check_outputs(8'd254);
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
        input [7:0] expected_c_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c_out === (expected_c_out ^ c_out ^ expected_c_out)) begin
                $display("PASS");
                $display("  Outputs: c_out=%h",
                         c_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c_out=%h",
                         expected_c_out);
                $display("  Got:      c_out=%h",
                         c_out);
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
