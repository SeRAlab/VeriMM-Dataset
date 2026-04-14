`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [15:0] c;
    reg sel;
    wire equal;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .sel(sel),
        .equal(equal),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a > b, sel=0 (Output larger value a)", test_num);
            a = 16'hA000;
            b = 16'h0005;
            c = 16'h1234;
            sel = 1'b0;
            #1;

            check_outputs(1'b0, 16'hA000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a < b, sel=0 (Output larger value b)", test_num);
            a = 16'h0005;
            b = 16'hB000;
            c = 16'h1234;
            sel = 1'b0;
            #1;

            check_outputs(1'b0, 16'hB000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a == b, sel=0 (Output a/b, equal high)", test_num);
            a = 16'hFFFF;
            b = 16'hFFFF;
            c = 16'h1234;
            sel = 1'b0;
            #1;

            check_outputs(1'b1, 16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a > b, sel=1 (Output c)", test_num);
            a = 16'hA000;
            b = 16'h0005;
            c = 16'hC0DE;
            sel = 1'b1;
            #1;

            check_outputs(1'b0, 16'hC0DE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a < b, sel=1 (Output c)", test_num);
            a = 16'h0005;
            b = 16'hB000;
            c = 16'hDEAD;
            sel = 1'b1;
            #1;

            check_outputs(1'b0, 16'hDEAD);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a == b, sel=1 (Output c, equal high)", test_num);
            a = 16'h1111;
            b = 16'h1111;
            c = 16'hBEEF;
            sel = 1'b1;
            #1;

            check_outputs(1'b1, 16'hBEEF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Edge case zeros, sel=0", test_num);
            a = 16'h0000;
            b = 16'h0000;
            c = 16'hFFFF;
            sel = 1'b0;
            #1;

            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large values comparison, sel=0", test_num);
            a = 16'h8000;
            b = 16'h7FFF;
            c = 16'h0000;
            sel = 1'b0;
            #1;

            check_outputs(1'b0, 16'h8000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: sel switching with constant inputs", test_num);
            a = 16'h000A;
            b = 16'h0005;
            c = 16'h000C;
            sel = 1'b0;
            #1;
            sel = 1'b1;
            #1;

            check_outputs(1'b0, 16'h000C);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max values check", test_num);
            a = 16'hFFFF;
            b = 16'h0000;
            c = 16'hAAAA;
            sel = 1'b0;
            #1;

            check_outputs(1'b0, 16'hFFFF);
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
        input expected_equal;
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_equal === (expected_equal ^ equal ^ expected_equal) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: equal=%b, out=%h",
                         equal, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: equal=%b, out=%h",
                         expected_equal, expected_out);
                $display("  Got:      equal=%b, out=%h",
                         equal, out);
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
