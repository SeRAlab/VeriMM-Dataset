`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [2:0] op;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .op(op),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: AND operation (op=0)", test_num);
            op = 3'd0;
            a = 16'hF0F0;
            b = 16'hAAAA;

            #1;


            check_outputs(16'hA0A0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: OR operation (op=1)", test_num);
            op = 3'd1;
            a = 16'hF0F0;
            b = 16'h0AAA;

            #1;


            check_outputs(16'hFAFA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: XOR operation (op=2)", test_num);
            op = 3'd2;
            a = 16'h1234;
            b = 16'h1234;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: NOT operation (op=3)", test_num);
            op = 3'd3;
            a = 16'h5555;
            b = 16'hFFFF;

            #1;


            check_outputs(16'hAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Left Shift (op=4, b=4)", test_num);
            op = 3'd4;
            a = 16'h0001;
            b = 16'h0004;

            #1;


            check_outputs(16'h0010);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Right Shift (op=5, b=4)", test_num);
            op = 3'd5;
            a = 16'h8000;
            b = 16'h0004;

            #1;


            check_outputs(16'h0800);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Left Shift Masking (op=4, b=0x0012 -> shift 2)", test_num);
            op = 3'd4;
            a = 16'h000F;
            b = 16'h0012;

            #1;


            check_outputs(16'h003C);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Right Shift Masking (op=5, b=0x0011 -> shift 1)", test_num);
            op = 3'd5;
            a = 16'h000F;
            b = 16'h0011;

            #1;


            check_outputs(16'h0007);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Left Shift Max (op=4, b=15)", test_num);
            op = 3'd4;
            a = 16'h0001;
            b = 16'h000F;

            #1;


            check_outputs(16'h8000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Right Shift Logical (op=5, b=8)", test_num);
            op = 3'd5;
            a = 16'hFF00;
            b = 16'h0008;

            #1;


            check_outputs(16'h00FF);
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
        input [15:0] expected_out;
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
