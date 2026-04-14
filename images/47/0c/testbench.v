`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;
    reg [3:0] data0;
    reg [3:0] data1;
    reg [3:0] data2;
    reg [3:0] data3;
    reg [3:0] data4;
    reg [3:0] data5;
    reg [2:0] sel;
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
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .data4(data4),
        .data5(data5),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: sel=0, data0=4'hA, a=8'h10 (min)", test_num);
            sel = 3'd0;
            data0 = 4'hA; data1 = 4'h0; data2 = 4'h0; data3 = 4'h0; data4 = 4'h0; data5 = 4'h0;
            a = 8'h10; b = 8'h20; c = 8'h30; d = 8'h40;

            #1;


            check_outputs(8'h1A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: sel=1, data1=4'h5, b=8'h05 (min)", test_num);
            sel = 3'd1;
            data0 = 4'h0; data1 = 4'h5; data2 = 4'h0; data3 = 4'h0; data4 = 4'h0; data5 = 4'h0;
            a = 8'hFF; b = 8'h05; c = 8'hAA; d = 8'h55;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: sel=2, data2=4'hF, c=8'h12 (min)", test_num);
            sel = 3'd2;
            data0 = 4'h0; data1 = 4'h0; data2 = 4'hF; data3 = 4'h0; data4 = 4'h0; data5 = 4'h0;
            a = 8'h80; b = 8'h70; c = 8'h12; d = 8'h22;

            #1;


            check_outputs(8'h1D);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: sel=3, data3=4'h0, d=8'h01 (min)", test_num);
            sel = 3'd3;
            data0 = 4'h1; data1 = 4'h2; data2 = 4'h3; data3 = 4'h0; data4 = 4'h5; data5 = 4'h6;
            a = 8'hEE; b = 8'hDD; c = 8'hCC; d = 8'h01;

            #1;


            check_outputs(8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: sel=4, data4=4'hC, min=8'hF0", test_num);
            sel = 3'd4;
            data0 = 4'h0; data1 = 4'h0; data2 = 4'h0; data3 = 4'h0; data4 = 4'hC; data5 = 4'h0;
            a = 8'hF0; b = 8'hF1; c = 8'hF2; d = 8'hF3;

            #1;


            check_outputs(8'hFC);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: sel=5, data5=4'h9, min=8'hAB", test_num);
            sel = 3'd5;
            data0 = 4'h1; data1 = 4'h2; data2 = 4'h3; data3 = 4'h4; data4 = 4'h5; data5 = 4'h9;
            a = 8'hAB; b = 8'hCD; c = 8'hEF; d = 8'hFF;

            #1;


            check_outputs(8'hA2);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple minimum values, sel=0", test_num);
            sel = 3'd0;
            data0 = 4'h1;
            a = 8'h02; b = 8'h02; c = 8'h02; d = 8'h02;

            #1;


            check_outputs(8'h03);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs zero", test_num);
            sel = 3'd0;
            data0 = 4'h0; data1 = 4'h0; data2 = 4'h0; data3 = 4'h0; data4 = 4'h0; data5 = 4'h0;
            a = 8'h00; b = 8'h00; c = 8'h00; d = 8'h00;
            #1;

            check_outputs(8'h00);
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
