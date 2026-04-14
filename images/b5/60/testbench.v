`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;
    reg [7:0] sel;
    wire [7:0] out;

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
            test_num = 1;
            $display("Test Case %0d: Select Input A (sel=00)", test_num);
            a = 8'hA1; b = 8'hB2; c = 8'hC3; d = 8'hD4;
            sel = 8'h00;
            #1;

            check_outputs(8'hA1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select Input B (sel=01)", test_num);
            a = 8'hA1; b = 8'hB2; c = 8'hC3; d = 8'hD4;
            sel = 8'h01;
            #1;

            check_outputs(8'hB2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Select Input C (sel=10)", test_num);
            a = 8'hA1; b = 8'hB2; c = 8'hC3; d = 8'hD4;
            sel = 8'h02;
            #1;

            check_outputs(8'hC3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Select Input D (sel=11)", test_num);
            a = 8'hA1; b = 8'hB2; c = 8'hC3; d = 8'hD4;
            sel = 8'h03;
            #1;

            check_outputs(8'hD4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: All Inputs Zero", test_num);
            a = 8'h00; b = 8'h00; c = 8'h00; d = 8'h00;
            sel = 8'h02;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: All Inputs Full Scale (FF)", test_num);
            a = 8'hFF; b = 8'hFF; c = 8'hFF; d = 8'hFF;
            sel = 8'h01;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Alternating Bits Logic", test_num);
            a = 8'h55; b = 8'hAA; c = 8'h33; d = 8'hCC;
            sel = 8'h00;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Change Data While Selected", test_num);
            a = 8'h11; b = 8'h22; c = 8'h33; d = 8'h44;
            sel = 8'h03;
            #5;
            d = 8'h99;
            #1;

            check_outputs(8'h99);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Check Select Bit 0 Sensitivity", test_num);
            a = 8'h10; b = 8'h20; c = 8'h30; d = 8'h40;
            sel = 8'h00;
            #5;
            sel = 8'h01;
            #1;

            check_outputs(8'h20);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Check Select Bit 1 Sensitivity", test_num);
            a = 8'h10; b = 8'h20; c = 8'h30; d = 8'h40;
            sel = 8'h00;
            #5;
            sel = 8'h02;
            #1;

            check_outputs(8'h30);
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
