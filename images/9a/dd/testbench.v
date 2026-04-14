`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg b;
    reg clk;
    reg [7:0] d;
    reg reset;
    reg sel_b1;
    reg sel_b2;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .d(d),
        .reset(reset),
        .sel_b1(sel_b1),
        .sel_b2(sel_b2),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            d = 8'h00;
            a = 0;
            b = 0;
            sel_b1 = 0;
            sel_b2 = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset value 0x34, Mux selection 'a' = 0", test_num);
            reset_dut();


            #1;
            #1;

            check_outputs(8'h34);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset value 0x34, Mux selection 'a' = 1", test_num);
            reset_dut();
            a = 1; b = 0; sel_b1 = 0; sel_b2 = 0;

            #1;
            #1;

            check_outputs(8'h35);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 0x00, Mux = 0", test_num);
            reset_dut();
            d = 8'h00;
            @(posedge clk);
            #1;
            a = 0; b = 0; sel_b1 = 0; sel_b2 = 0;
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 0x00, Mux selection 'b' = 1", test_num);
            reset_dut();
            d = 8'h00;
            @(posedge clk);
            #1;
            a = 0; b = 1; sel_b1 = 1; sel_b2 = 1;
            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 0xAA, Mux = 1", test_num);
            reset_dut();
            d = 8'hAA;
            @(posedge clk);
            #1;
            a = 1; b = 0; sel_b1 = 0; sel_b2 = 0;

            #1;
            #1;

            check_outputs(8'hAB);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 0xFE, Mux = 1 -> 0xFF", test_num);
            reset_dut();
            d = 8'hFE;
            @(posedge clk);
            #1;
            a = 1; b = 0; sel_b1 = 0; sel_b2 = 0;
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 0x00, Mux select partial (sel_b1=1, sel_b2=0 selects a)", test_num);
            reset_dut();
            d = 8'h00;
            @(posedge clk);
            #1;
            a = 1; b = 0; sel_b1 = 1; sel_b2 = 0;
            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 0x50, Mux select b=1 via sel_b1/sel_b2", test_num);
            reset_dut();
            d = 8'h50;
            @(posedge clk);
            #1;
            a = 0; b = 1; sel_b1 = 1; sel_b2 = 1;
            #1;
            #1;

            check_outputs(8'h51);
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
        input [7:0] expected_q;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,a, b, clk, d, reset, sel_b1, sel_b2, q);
    end

endmodule
