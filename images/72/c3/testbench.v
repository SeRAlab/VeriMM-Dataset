`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg select;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .select(select),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Select A (a=0xAA, b=0x55, select=0)", test_num);
            a = 8'hAA;
            b = 8'h55;
            select = 1'b0;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Select B (a=0xAA, b=0x55, select=1)", test_num);
            a = 8'hAA;
            b = 8'h55;
            select = 1'b1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Select A with all zeros (a=0x00, b=0xFF, select=0)", test_num);
            a = 8'h00;
            b = 8'hFF;
            select = 1'b0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Select B with all ones (a=0x00, b=0xFF, select=1)", test_num);
            a = 8'h00;
            b = 8'hFF;
            select = 1'b1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Select A with alternating bits (a=0xA5, b=0x5A, select=0)", test_num);
            a = 8'hA5;
            b = 8'h5A;
            select = 1'b0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Select B with alternating bits (a=0xA5, b=0x5A, select=1)", test_num);
            a = 8'hA5;
            b = 8'h5A;
            select = 1'b1;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Random pattern A (a=0x12, b=0x34, select=0)", test_num);
            a = 8'h12;
            b = 8'h34;
            select = 1'b0;
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Random pattern B (a=0x12, b=0x34, select=1)", test_num);
            a = 8'h12;
            b = 8'h34;
            select = 1'b1;
            #1;

            check_outputs(8'h34);
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
        input [7:0] expected_out;
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
