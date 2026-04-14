`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in1;
    reg [15:0] in2;
    reg sel;
    reg [3:0] shift_amt;
    wire [15:0] out;
    wire parity;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .sel(sel),
        .shift_amt(shift_amt),
        .out(out),
        .parity(parity)
    );
    task testcase001;

    begin
        test_num = 1;
        in1 = 16'h0001; in2 = 16'hFFFF; shift_amt = 4'd0; sel = 1'b0;
        #10;

        #1;


        check_outputs(16'h0001, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in1 = 16'h0001; in2 = 16'hFFFF; shift_amt = 4'd1; sel = 1'b0;
        #10;

        #1;


        check_outputs(16'h0002, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in1 = 16'h000F; in2 = 16'h0000; shift_amt = 4'd4; sel = 1'b0;
        #10;

        #1;


        check_outputs(16'h00F0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in1 = 16'h00FF; in2 = 16'h0000; shift_amt = 4'd8; sel = 1'b0;
        #10;

        #1;


        check_outputs(16'hFF00, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in1 = 16'h0001; in2 = 16'h0000; shift_amt = 4'd15; sel = 1'b0;
        #10;

        #1;


        check_outputs(16'h8000, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in1 = 16'hFFFF; in2 = 16'hAAAA; shift_amt = 4'd4; sel = 1'b1;
        #10;

        #1;


        check_outputs(16'hAAAA, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in1 = 16'h0000; in2 = 16'h1234; shift_amt = 4'd0; sel = 1'b1;
        #10;

        #1;


        check_outputs(16'h1234, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in1 = 16'h0000; in2 = 16'hFFFF; shift_amt = 4'd0; sel = 1'b1;
        #10;

        #1;


        check_outputs(16'hFFFF, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        in1 = 16'hF000; in2 = 16'h0000; shift_amt = 4'd4; sel = 1'b0;
        #10;

        #1;


        check_outputs(16'h0000, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        in1 = 16'h0001; in2 = 16'h0003; shift_amt = 4'd0;
        sel = 1'b0; #5;
        sel = 1'b1; #5;

        #1;


        check_outputs(16'h0003, 1'b0);
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
        input [15:0] expected_out;
        input expected_parity;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_parity === (expected_parity ^ parity ^ expected_parity)) begin
                $display("PASS");
                $display("  Outputs: out=%h, parity=%b",
                         out, parity);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, parity=%b",
                         expected_out, expected_parity);
                $display("  Got:      out=%h, parity=%b",
                         out, parity);
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
