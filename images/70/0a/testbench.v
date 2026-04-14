`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] a;
    reg [4:0] b;
    reg [4:0] c;
    reg [4:0] d;
    reg [1:0] sel;
    wire [4:0] o;

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
            $display("Test Case 001: Select input 'a' (sel=00)");
            test_num = 1;
            a = 5'h0A; b = 5'h15; c = 5'h00; d = 5'h1F;
            sel = 2'b00;
            #1;

            check_outputs(5'h0A);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Select input 'b' (sel=01)");
            test_num = 2;
            a = 5'h0A; b = 5'h15; c = 5'h00; d = 5'h1F;
            sel = 2'b01;
            #1;

            check_outputs(5'h15);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Select input 'c' (sel=10)");
            test_num = 3;
            a = 5'h0A; b = 5'h15; c = 5'h0E; d = 5'h1F;
            sel = 2'b10;
            #1;

            check_outputs(5'h0E);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Select input 'd' (sel=11)");
            test_num = 4;
            a = 5'h0A; b = 5'h15; c = 5'h0E; d = 5'h1F;
            sel = 2'b11;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Boundary test - All Inputs High, sel=00");
            test_num = 5;
            a = 5'b11111; b = 5'b11111; c = 5'b11111; d = 5'b11111;
            sel = 2'b00;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Boundary test - All Inputs Low, sel=01");
            test_num = 6;
            a = 5'b00000; b = 5'b00000; c = 5'b00000; d = 5'b00000;
            sel = 2'b01;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Walking 1s - select 'c' (sel=10)");
            test_num = 7;
            a = 5'h01; b = 5'h02; c = 5'h04; d = 5'h08;
            sel = 2'b10;
            #1;

            check_outputs(5'h04);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Verify change in inactive inputs - select 'a' (sel=00)");
            test_num = 8;
            a = 5'h12; b = 5'h00; c = 5'h00; d = 5'h00;
            sel = 2'b00;
            #5;
            b = 5'h1F; c = 5'h1F; d = 5'h1F;
            #1;

            check_outputs(5'h12);
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
        input [4:0] expected_o;
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
