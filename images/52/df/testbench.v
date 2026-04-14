`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [31:0] c;
    reg [31:0] d;
    reg [1:0] sel;
    wire [31:0] o;

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
        .o(o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Input A (sel=00)", test_num);
            a = 32'hA5A5A5A5;
            b = 32'h5A5A5A5A;
            c = 32'h12345678;
            d = 32'h87654321;
            sel = 2'b00;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Input B (sel=01)", test_num);
            a = 32'hA5A5A5A5;
            b = 32'h5A5A5A5A;
            c = 32'h12345678;
            d = 32'h87654321;
            sel = 2'b01;
            #1;

            check_outputs(32'h5A5A5A5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Input C (sel=10)", test_num);
            a = 32'hA5A5A5A5;
            b = 32'h5A5A5A5A;
            c = 32'h12345678;
            d = 32'h87654321;
            sel = 2'b10;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Input D (sel=11)", test_num);
            a = 32'hA5A5A5A5;
            b = 32'h5A5A5A5A;
            c = 32'h12345678;
            d = 32'h87654321;
            sel = 2'b11;
            #1;

            check_outputs(32'h87654321);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero, sel=01", test_num);
            a = 32'h0; b = 32'h0; c = 32'h0; d = 32'h0;
            sel = 2'b01;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs F's, sel=11", test_num);
            a = 32'hFFFFFFFF; b = 32'hFFFFFFFF; c = 32'hFFFFFFFF; d = 32'hFFFFFFFF;
            sel = 2'b11;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern toggling, sel=10", test_num);
            a = 32'h00000000;
            b = 32'hFFFFFFFF;
            c = 32'hCAFEBABE;
            d = 32'hDEADBEEF;
            sel = 2'b10;
            #1;

            check_outputs(32'hCAFEBABE);
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
        input [31:0] expected_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%h",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%h",
                         expected_o);
                $display("  Got:      o=%h",
                         o);
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
