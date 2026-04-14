`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] col_in;
    wire [7:0] byte_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .col_in(col_in),
        .byte_out(byte_out)
    );
    task testcase001;

    begin
        test_num = 1;
        col_in = 32'h00000000;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        col_in = 32'h01000000;
        #1;

        check_outputs(8'h02);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        col_in = 32'h00010000;
        #1;

        check_outputs(8'h03);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        col_in = 32'h00000100;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        col_in = 32'h00000001;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        col_in = 32'hd4bf5d30;
        #1;

        check_outputs(8'h04);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        col_in = 32'hdb135345;
        #1;

        check_outputs(8'h8e);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        col_in = 32'hf20a225c;
        #1;

        check_outputs(8'h9f);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        col_in = 32'h26262626;
        #1;

        check_outputs(8'h26);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        col_in = 32'h80000000;
        #1;

        check_outputs(8'h1b);
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
        input [7:0] expected_byte_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_byte_out === (expected_byte_out ^ byte_out ^ expected_byte_out)) begin
                $display("PASS");
                $display("  Outputs: byte_out=%h",
                         byte_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: byte_out=%h",
                         expected_byte_out);
                $display("  Got:      byte_out=%h",
                         byte_out);
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
