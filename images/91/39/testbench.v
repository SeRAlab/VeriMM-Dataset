`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;
    reg [3:0] sel;
    wire [7:0] mux_out;

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
        .mux_out(mux_out)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 8'hA1; b = 8'hB2; c = 8'hC3; d = 8'hD4;
        sel = 4'd0;
        $display("Test Case %0d: Selecting Input A (sel=0)", test_num);
        #1;

        check_outputs(8'hA1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 8'hA1; b = 8'hB2; c = 8'hC3; d = 8'hD4;
        sel = 4'd1;
        $display("Test Case %0d: Selecting Input B (sel=1)", test_num);
        #1;

        check_outputs(8'hB2);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 8'hA1; b = 8'hB2; c = 8'hC3; d = 8'hD4;
        sel = 4'd2;
        $display("Test Case %0d: Selecting Input C (sel=2)", test_num);
        #1;

        check_outputs(8'hC3);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 8'hA1; b = 8'hB2; c = 8'hC3; d = 8'hD4;
        sel = 4'd3;
        $display("Test Case %0d: Selecting Input D (sel=3)", test_num);
        #1;

        check_outputs(8'hD4);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 8'hFF; b = 8'h00; c = 8'h55; d = 8'hAA;
        sel = 4'd4;
        $display("Test Case %0d: Flexibility Check - Selecting Input A again (sel=4)", test_num);
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 8'hFF; b = 8'h00; c = 8'h55; d = 8'hAA;
        sel = 4'd7;
        $display("Test Case %0d: Flexibility Check - Selecting Input D again (sel=7)", test_num);
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 8'h10; b = 8'h20; c = 8'h30; d = 8'h40;
        sel = 4'd8;
        $display("Test Case %0d: Selecting Input A (sel=8)", test_num);
        #1;

        check_outputs(8'h10);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 8'h10; b = 8'h20; c = 8'h30; d = 8'h40;
        sel = 4'd15;
        $display("Test Case %0d: Selecting Input D (sel=15)", test_num);
        #1;

        check_outputs(8'h40);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 8'hEE; b = 8'hEE; c = 8'hEE; d = 8'hEE;
        sel = 4'd10;
        $display("Test Case %0d: All inputs same, checking stability", test_num);
        #1;

        check_outputs(8'hEE);
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
        input [7:0] expected_mux_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mux_out === (expected_mux_out ^ mux_out ^ expected_mux_out)) begin
                $display("PASS");
                $display("  Outputs: mux_out=%h",
                         mux_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mux_out=%h",
                         expected_mux_out);
                $display("  Got:      mux_out=%h",
                         mux_out);
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
