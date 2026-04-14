`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] byte_num;
    reg [63:0] in;
    wire [63:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .byte_num(byte_num),
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            in = 64'h0123456789ABCDEF;
            byte_num = 3'd0;
            #1;

            check_outputs(64'h0123456789ABCD01);
        end
        endtask

    task testcase002;

        begin
            in = 64'h0123456789ABCDEF;
            byte_num = 3'd1;
            #1;

            check_outputs(64'h0123456789AB0100);
        end
        endtask

    task testcase003;

        begin
            in = 64'hFEDCBA9876543210;
            byte_num = 3'd2;
            #1;

            check_outputs(64'hFEDCBA9876010000);
        end
        endtask

    task testcase004;

        begin
            in = 64'hFFFFFFFFFFFFFFFF;
            byte_num = 3'd3;
            #1;

            check_outputs(64'hFFFFFFFF01000000);
        end
        endtask

    task testcase005;

        begin
            in = 64'hAAAAAAAAAAAAAAAA;
            byte_num = 3'd4;
            #1;

            check_outputs(64'hAAAAAA0100000000);
        end
        endtask

    task testcase006;

        begin
            in = 64'h5555555555555555;
            byte_num = 3'd5;
            #1;

            check_outputs(64'h5555010000000000);
        end
        endtask

    task testcase007;

        begin
            in = 64'h0011223344556677;
            byte_num = 3'd6;
            #1;

            check_outputs(64'h0001000000000000);
        end
        endtask

    task testcase008;

        begin
            in = 64'h8899AABBCCDDEEFF;
            byte_num = 3'd7;
            #1;

            check_outputs(64'h0100000000000000);
        end
        endtask

    task testcase009;

        begin
            in = 64'hDEADBEEFCAFEBABE;
            byte_num = 3'd4;
            #1;

            check_outputs(64'hDEADBE0100000000);
        end
        endtask

    task testcase010;

        begin
            in = 64'h0000000000000000;
            byte_num = 3'd0;
            #1;

            check_outputs(64'h0000000000000001);
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
        input [63:0] expected_out;
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
