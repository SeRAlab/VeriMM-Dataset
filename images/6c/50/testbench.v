`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [15:0] c;
    reg [15:0] d;
    reg [15:0] e;
    reg [15:0] f;
    reg [15:0] g;
    reg [15:0] h;
    reg [2:0] sel;
    wire [15:0] y;

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
        .e(e),
        .f(f),
        .g(g),
        .h(h),
        .sel(sel),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select input 'a' (sel=0)", test_num);
            a = 16'hAAAA; b = 16'h0000; c = 16'h0000; d = 16'h0000;
            e = 16'h0000; f = 16'h0000; g = 16'h0000; h = 16'h0000;
            sel = 3'b000;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select input 'b' (sel=1)", test_num);
            a = 16'h0000; b = 16'h5555; c = 16'h0000; d = 16'h0000;
            e = 16'h0000; f = 16'h0000; g = 16'h0000; h = 16'h0000;
            sel = 3'b001;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select input 'c' (sel=2)", test_num);
            a = 16'h0000; b = 16'h0000; c = 16'h1234; d = 16'h0000;
            e = 16'h0000; f = 16'h0000; g = 16'h0000; h = 16'h0000;
            sel = 3'b010;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select input 'd' (sel=3)", test_num);
            a = 16'h0000; b = 16'h0000; c = 16'h0000; d = 16'hABCD;
            e = 16'h0000; f = 16'h0000; g = 16'h0000; h = 16'h0000;
            sel = 3'b011;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Select input 'e' (sel=4)", test_num);
            a = 16'h0000; b = 16'h0000; c = 16'h0000; d = 16'h0000;
            e = 16'hFFFF; f = 16'h0000; g = 16'h0000; h = 16'h0000;
            sel = 3'b100;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Select input 'f' (sel=5)", test_num);
            a = 16'h0000; b = 16'h0000; c = 16'h0000; d = 16'h0000;
            e = 16'h0000; f = 16'h7777; g = 16'h0000; h = 16'h0000;
            sel = 3'b101;
            #1;

            check_outputs(16'h7777);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Select input 'g' (sel=6)", test_num);
            a = 16'h0000; b = 16'h0000; c = 16'h0000; d = 16'h0000;
            e = 16'h0000; f = 16'h0000; g = 16'h8888; h = 16'h0000;
            sel = 3'b110;
            #1;

            check_outputs(16'h8888);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Select input 'h' (sel=7)", test_num);
            a = 16'h0000; b = 16'h0000; c = 16'h0000; d = 16'h0000;
            e = 16'h0000; f = 16'h0000; g = 16'h0000; h = 16'hDEAD;
            sel = 3'b111;
            #1;

            check_outputs(16'hDEAD);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Switching select with all unique inputs", test_num);
            a = 16'h1; b = 16'h2; c = 16'h3; d = 16'h4;
            e = 16'h5; f = 16'h6; g = 16'h7; h = 16'h8;

            sel = 3'b010;
            #1;

            check_outputs(16'h3);

            sel = 3'b101;
            #1;

            check_outputs(16'h6);
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
        input [15:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
