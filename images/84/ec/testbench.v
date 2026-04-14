`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] D;
    reg [15:0] in;
    reg [3:0] sel;
    wire [2:0] EN;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .in(in),
        .sel(sel),
        .EN(EN),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        in = 16'h0000;
        sel = 4'h0;
        D = 8'h00;
        #1;

        check_outputs(3'd0, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in = 16'hA53C;
        sel = 4'h0;
        D = 8'h00;
        #1;

        check_outputs(3'd0, 8'h3C);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in = 16'hA53C;
        sel = 4'h8;
        D = 8'h00;
        #1;

        check_outputs(3'd0, 8'hA5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in = 16'h0000;
        sel = 4'h0;
        D = 8'h80;
        #1;

        check_outputs(3'd7, 8'h07);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in = 16'h0000;
        sel = 4'h0;
        D = 8'h1A;
        #1;

        check_outputs(3'd4, 8'h04);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in = 16'h0050;
        sel = 4'h2;
        D = 8'h08;

        #1;


        check_outputs(3'd3, 8'h53);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in = 16'hF00F;
        sel = 4'hC;
        D = 8'h02;

        #1;


        check_outputs(3'd1, 8'hF1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in = 16'hAABB;
        sel = 4'h7;
        D = 8'h00;
        #1;

        check_outputs(3'd0, 8'hBB);
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
        input [2:0] expected_EN;
        input [7:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EN === (expected_EN ^ EN ^ expected_EN) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: EN=%h, out=%h",
                         EN, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EN=%h, out=%h",
                         expected_EN, expected_out);
                $display("  Got:      EN=%h, out=%h",
                         EN, out);
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
