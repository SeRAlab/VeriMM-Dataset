`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg f;
    reg no;
    reg nx;
    reg ny;
    reg [15:0] x;
    reg [15:0] y;
    reg zx;
    reg zy;
    wire ng;
    wire [15:0] out;
    wire zr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .f(f),
        .no(no),
        .nx(nx),
        .ny(ny),
        .x(x),
        .y(y),
        .zx(zx),
        .zy(zy),
        .ng(ng),
        .out(out),
        .zr(zr)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Constant 0", test_num);
            x = 16'h1234; y = 16'h5678;
            zx = 1; nx = 0; zy = 1; ny = 0; f = 1; no = 0;
            #1;

            check_outputs(0, 16'h0000, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Constant 1", test_num);
            x = 16'hAAAA; y = 16'h5555;
            zx = 1; nx = 1; zy = 1; ny = 1; f = 1; no = 1;
            #1;

            check_outputs(0, 16'h0001, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Constant -1", test_num);
            x = 16'h0000; y = 16'h0000;
            zx = 1; nx = 1; zy = 1; ny = 0; f = 1; no = 0;
            #1;

            check_outputs(1, 16'hFFFF, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pass through x", test_num);
            x = 16'h1234; y = 16'hFFFF;
            zx = 0; nx = 0; zy = 1; ny = 1; f = 0; no = 0;
            #1;

            check_outputs(0, 16'h1234, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pass through y", test_num);
            x = 16'h0000; y = 16'hABCD;
            zx = 1; nx = 1; zy = 0; ny = 0; f = 0; no = 0;
            #1;

            check_outputs(1, 16'hABCD, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise NOT x", test_num);
            x = 16'h0F0F; y = 16'h0000;
            zx = 0; nx = 0; zy = 1; ny = 1; f = 0; no = 1;
            #1;

            check_outputs(1, 16'hF0F0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise NOT y", test_num);
            x = 16'hFFFF; y = 16'hF0F0;
            zx = 1; nx = 1; zy = 0; ny = 0; f = 0; no = 1;
            #1;

            check_outputs(0, 16'h0F0F, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negate -x", test_num);
            x = 16'h000A; y = 16'h0000;
            zx = 0; nx = 0; zy = 1; ny = 1; f = 1; no = 1;
            #1;

            check_outputs(1, 16'hFFF6, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: x + 1", test_num);
            x = 16'h001F; y = 16'h0000;
            zx = 0; nx = 1; zy = 1; ny = 1; f = 1; no = 1;
            #1;

            check_outputs(0, 16'h0020, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: x - 1", test_num);
            x = 16'h0001; y = 16'h0000;
            zx = 0; nx = 0; zy = 1; ny = 1; f = 1; no = 0;
            #1;

            check_outputs(0, 16'h0000, 1);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: x + y", test_num);
            x = 16'h0010; y = 16'h0020;
            zx = 0; nx = 0; zy = 0; ny = 0; f = 1; no = 0;
            #1;

            check_outputs(0, 16'h0030, 0);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: x - y", test_num);
            x = 16'h000A; y = 16'h0003;
            zx = 0; nx = 1; zy = 0; ny = 0; f = 1; no = 1;
            #1;

            check_outputs(0, 16'h0007, 0);
        end
        endtask

    task testcase013;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: y - x", test_num);
            x = 16'h000A; y = 16'h0003;
            zx = 0; nx = 0; zy = 0; ny = 1; f = 1; no = 1;
            #1;

            check_outputs(1, 16'hFFF9, 0);
        end
        endtask

    task testcase014;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: x & y", test_num);
            x = 16'h00FF; y = 16'h0F0F;
            zx = 0; nx = 0; zy = 0; ny = 0; f = 0; no = 0;
            #1;

            check_outputs(0, 16'h000F, 0);
        end
        endtask

    task testcase015;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: x | y", test_num);
            x = 16'hF0F0; y = 16'h0F0F;
            zx = 0; nx = 1; zy = 0; ny = 1; f = 0; no = 1;
            #1;

            check_outputs(1, 16'hFFFF, 0);
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        
        
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
        input expected_ng;
        input [15:0] expected_out;
        input expected_zr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ng === (expected_ng ^ ng ^ expected_ng) &&
                expected_out === (expected_out ^ out ^ expected_out) &&
                expected_zr === (expected_zr ^ zr ^ expected_zr)) begin
                $display("PASS");
                $display("  Outputs: ng=%b, out=%h, zr=%b",
                         ng, out, zr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ng=%b, out=%h, zr=%b",
                         expected_ng, expected_out, expected_zr);
                $display("  Got:      ng=%b, out=%h, zr=%b",
                         ng, out, zr);
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
