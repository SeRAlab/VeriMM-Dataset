`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg sel;
    wire [15:0] mux_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .sel(sel),
        .mux_out(mux_out)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 8'hA5;
        b = 8'h5A;
        sel = 1'b0;
        #10;
        $display("Testcase %03d: Selecting 'a' (h%h)", test_num, a);
        #1;

        check_outputs(16'h00A5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 8'hA5;
        b = 8'h5A;
        sel = 1'b1;
        #10;
        $display("Testcase %03d: Selecting 'b' (h%h)", test_num, b);
        #1;

        check_outputs(16'h005A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 8'hFF;
        b = 8'h00;
        sel = 1'b0;
        #10;
        $display("Testcase %03d: Selecting 'a' (h%h)", test_num, a);
        #1;

        check_outputs(16'h00FF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 8'hFF;
        b = 8'h00;
        sel = 1'b1;
        #10;
        $display("Testcase %03d: Selecting 'b' (h%h)", test_num, b);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 8'h00;
        b = 8'hFF;
        sel = 1'b1;
        #10;
        $display("Testcase %03d: Selecting 'b' (h%h)", test_num, b);
        #1;

        check_outputs(16'h00FF);
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
        input [15:0] expected_mux_out;
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
