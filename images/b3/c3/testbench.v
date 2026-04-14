`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg [3:0] d;
    reg [1:0] sel;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            a = 4'b1010;
            b = 4'b0000;
            c = 4'b1111;
            d = 4'b0101;
            sel = 2'b00;
            $display("Test %0d: Selecting Input A (sel=00)", test_num);
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            a = 4'b1010;
            b = 4'b0110;
            c = 4'b1111;
            d = 4'b0101;
            sel = 2'b01;
            $display("Test %0d: Selecting Input B (sel=01)", test_num);
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            a = 4'b1010;
            b = 4'b0110;
            c = 4'b0011;
            d = 4'b0101;
            sel = 2'b10;
            $display("Test %0d: Selecting Input C (sel=10)", test_num);
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a = 4'b1010;
            b = 4'b0110;
            c = 4'b0011;
            d = 4'b1100;
            sel = 2'b11;
            $display("Test %0d: Selecting Input D (sel=11)", test_num);
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;

            a = 4'b1111;
            b = 4'b0000;
            c = 4'b1111;
            d = 4'b0000;

            sel = 2'b00;
            $display("Test %0d: Data Sensitivity Check (sel=00, all 1s)", test_num);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            a = 4'b1111;
            b = 4'b0101;
            c = 4'b1111;
            d = 4'b0000;

            sel = 2'b01;
            $display("Test %0d: Data Sensitivity Check (sel=01, pattern 0101)", test_num);
            #1;

            check_outputs(4'b0101);
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
        input [3:0] expected_out;
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
