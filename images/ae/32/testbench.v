`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] d0;
    reg [3:0] d1;
    reg [3:0] d2;
    reg [3:0] d3;
    reg [1:0] sel;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3),
        .sel(sel),
        .q(q)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Select d0 (sel=00)", test_num);
        d0 = 4'hA; d1 = 4'h5; d2 = 4'h3; d3 = 4'h1;
        sel = 2'b00;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Select d1 (sel=01)", test_num);
        d0 = 4'hA; d1 = 4'h5; d2 = 4'h3; d3 = 4'h1;
        sel = 2'b01;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Select d2 (sel=10)", test_num);
        d0 = 4'hA; d1 = 4'h5; d2 = 4'h3; d3 = 4'h1;
        sel = 2'b10;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Select d3 (sel=11)", test_num);
        d0 = 4'hA; d1 = 4'h5; d2 = 4'h3; d3 = 4'h1;
        sel = 2'b11;
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: All inputs same, expect matching output", test_num);
        d0 = 4'hF; d1 = 4'hF; d2 = 4'hF; d3 = 4'hF;
        sel = 2'b10;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Select d0 with different value", test_num);
        d0 = 4'h7; d1 = 4'h0; d2 = 4'h0; d3 = 4'h0;
        sel = 2'b00;
        #1;

        check_outputs(4'h7);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Select d3 with zeros", test_num);
        d0 = 4'hF; d1 = 4'hF; d2 = 4'hF; d3 = 4'h0;
        sel = 2'b11;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Alternating bit pattern on d2", test_num);
        d0 = 4'h0; d1 = 4'h0; d2 = 4'h5; d3 = 4'h0;
        sel = 2'b10;
        #1;

        check_outputs(4'h5);
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
