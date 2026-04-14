`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;
    reg [1:0] sel;
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
            $display("Test %0d: Select input 'a' (sel=00)", test_num);
            a = 8'hAA;
            b = 8'hBB;
            c = 8'hCC;
            d = 8'hDD;
            sel = 2'b00;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Select input 'b' (sel=01)", test_num);
            a = 8'hAA;
            b = 8'hBB;
            c = 8'hCC;
            d = 8'hDD;
            sel = 2'b01;
            #1;

            check_outputs(8'hBB);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Select input 'c' (sel=10)", test_num);
            a = 8'hAA;
            b = 8'hBB;
            c = 8'hCC;
            d = 8'hDD;
            sel = 2'b10;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Select input 'd' (sel=11)", test_num);
            a = 8'hAA;
            b = 8'hBB;
            c = 8'hCC;
            d = 8'hDD;
            sel = 2'b11;
            #1;

            check_outputs(8'hDD);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: All inputs identical (0xFF)", test_num);
            a = 8'hFF;
            b = 8'hFF;
            c = 8'hFF;
            d = 8'hFF;
            sel = 2'b10;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: All inputs identical (0x00)", test_num);
            a = 8'h00;
            b = 8'h00;
            c = 8'h00;
            d = 8'h00;
            sel = 2'b01;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Walking bit test on input 'a'", test_num);
            a = 8'h01; b = 8'h00; c = 8'h00; d = 8'h00; sel = 2'b00;
            #1; a = 8'h02; #1; a = 8'h04; #1; a = 8'h08;
            #1; a = 8'h10; #1; a = 8'h20; #1; a = 8'h40;
            #1; a = 8'h80;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Alternating bits test", test_num);
            a = 8'h55;
            b = 8'hAA;
            c = 8'h00;
            d = 8'hFF;
            sel = 2'b00;
            #5;
            sel = 2'b01;
            #1;

            check_outputs(8'hAA);
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
