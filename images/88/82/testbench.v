`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
    reg reset;
    reg sel;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .reset(reset),
        .sel(sel),
        .q(q)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Synchronous Reset", test_num);
            a = 4'hF; b = 4'hF; sel = 0;
            reset = 1;
            @(posedge clk);
            reset = 0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition Mode (3 + 4)", test_num);
            reset = 1; @(posedge clk); reset = 0;
            a = 4'd3; b = 4'd4; sel = 0;
            @(posedge clk);
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition Mode (12 + 5 with truncation)", test_num);
            reset = 1; @(posedge clk); reset = 0;
            a = 4'd12; b = 4'd5; sel = 0;
            @(posedge clk);
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mux Mode (a > b, expect a)", test_num);
            reset = 1; @(posedge clk); reset = 0;
            a = 4'b1010; b = 4'b0101; sel = 1;
            @(posedge clk);
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mux Mode (a < b, expect ~a)", test_num);
            reset = 1; @(posedge clk); reset = 0;
            a = 4'b0011; b = 4'b1100; sel = 1;
            @(posedge clk);
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mux Mode (a == b, expect ~a)", test_num);
            reset = 1; @(posedge clk); reset = 0;
            a = 4'b1111; b = 4'b1111; sel = 1;
            @(posedge clk);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mode Switch (Mux to Add)", test_num);
            reset = 1; @(posedge clk); reset = 0;

            a = 4'b0001; b = 4'b0000; sel = 1;
            @(posedge clk);

            a = 4'd5; b = 4'd5; sel = 0;
            @(posedge clk);
            #1;

            check_outputs(4'd10);
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
        input [3:0] expected_q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
