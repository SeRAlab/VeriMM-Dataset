`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [39:0] a;
    reg [39:0] b;
    reg clk;
    reg ena;
    reg is_cssu;
    reg [39:0] s;
    reg sel_acc;
    wire [15:0] result;
    wire tco;
    wire [15:0] trn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .ena(ena),
        .is_cssu(is_cssu),
        .s(s),
        .sel_acc(sel_acc),
        .result(result),
        .tco(tco),
        .trn(trn)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ena = 0;
            a = 40'h0;
            b = 40'h0;
            s = 40'hFFFFFFFFFF;
            sel_acc = 0;
            is_cssu = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Accumulation (B)", test_num);
            reset_dut();


            a = 40'h0;
            b = 40'h0000001234;
            s = 40'h000000FFFF;
            sel_acc = 0;
            is_cssu = 0;
            ena = 1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(16'h1234, 1'b0, 16'h0000);
            ena = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Input A", test_num);
            reset_dut();

            a = 40'h000000ABCD;
            b = 40'h0;
            s = 40'h000000FFFF;
            sel_acc = 1;
            is_cssu = 0;
            ena = 1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(16'hABCD, 1'b0, 16'h0000);
            ena = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Comparison Match (tco high)", test_num);
            reset_dut();


            a = 40'h0000008000;
            s = 40'h0000005000;
            sel_acc = 1;
            is_cssu = 0;
            ena = 1;

            @(posedge clk);
            #2;




            if (tco === 1'b1 && trn[0] === 1'b1) begin
                $display("PASS: Comparison triggered correctly");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Comparison did not trigger. tco=%b trn=%h", tco, trn);
                fail_count = fail_count + 1;
            end
            ena = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High Half Selection", test_num);
            reset_dut();



            a = 40'h0012345678;
            s = 40'hFFFFFFFFFF;
            sel_acc = 1;
            is_cssu = 1;
            ena = 1;

            @(posedge clk);
            #2;



            #1;




            check_outputs(16'h1234, 1'b0, 16'h0000);
            ena = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: TRN Shifting Sequence", test_num);
            reset_dut();

            s = 40'h0000000005;
            a = 40'h0000000010;
            sel_acc = 1;
            ena = 1;


            @(posedge clk); #2;

            @(posedge clk); #2;

            @(posedge clk); #2;

            if (trn[2:0] === 3'b111) begin
                $display("PASS: TRN shifted 3 bits correctly");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: TRN shift incorrect. trn=%h", trn);
                fail_count = fail_count + 1;
            end
            ena = 0;
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
        input [15:0] expected_result;
        input expected_tco;
        input [15:0] expected_trn;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_tco === (expected_tco ^ tco ^ expected_tco) &&
                expected_trn === (expected_trn ^ trn ^ expected_trn)) begin
                $display("PASS");
                $display("  Outputs: result=%h, tco=%b, trn=%h",
                         result, tco, trn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, tco=%b, trn=%h",
                         expected_result, expected_tco, expected_trn);
                $display("  Got:      result=%h, tco=%b, trn=%h",
                         result, tco, trn);
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
        $dumpvars(0,a, b, clk, ena, is_cssu, s, sel_acc, result, tco, trn);
    end

endmodule
