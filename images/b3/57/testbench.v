`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg control;
    reg [3:0] data0;
    reg [3:0] data1;
    reg [3:0] data2;
    reg [3:0] data3;
    reg [3:0] data4;
    reg [3:0] data5;
    reg [3:0] in1;
    reg [3:0] in2;
    reg [2:0] sel;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .control(control),
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .data4(data4),
        .data5(data5),
        .in1(in1),
        .in2(in2),
        .sel(sel),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Addition (5 + 3) and MUX Selection 0", test_num);
        in1 = 4'h5;
        in2 = 4'h3;
        control = 1'b0;
        sel = 3'd0;
        data0 = 4'hA; data1 = 4'h0; data2 = 4'h0; data3 = 4'h0; data4 = 4'h0; data5 = 4'h0;

        #1;


        check_outputs(8'hA8);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Subtraction (10 - 4) and MUX Selection 1", test_num);
        in1 = 4'd10;
        in2 = 4'd4;
        control = 1'b1;
        sel = 3'd1;
        data0 = 4'h0; data1 = 4'hB; data2 = 4'h0; data3 = 4'h0; data4 = 4'h0; data5 = 4'h0;

        #1;


        check_outputs(8'hB6);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Addition with Overflow (15 + 2) and MUX Selection 2", test_num);
        in1 = 4'hF;
        in2 = 4'h2;
        control = 1'b0;
        sel = 3'd2;
        data0 = 4'h0; data1 = 4'h0; data2 = 4'hC; data3 = 4'h0; data4 = 4'h0; data5 = 4'h0;

        #1;


        check_outputs(8'hC1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Subtraction with Negative Result (2 - 5) and MUX Selection 3", test_num);
        in1 = 4'h2;
        in2 = 4'h5;
        control = 1'b1;
        sel = 3'd3;
        data0 = 4'h0; data1 = 4'h0; data2 = 4'h0; data3 = 4'hD; data4 = 4'h0; data5 = 4'h0;

        #1;


        check_outputs(8'hDD);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Addition (8 + 7) and MUX Selection 4", test_num);
        in1 = 4'h8;
        in2 = 4'h7;
        control = 1'b0;
        sel = 3'd4;
        data0 = 4'h0; data1 = 4'h0; data2 = 4'h0; data3 = 4'h0; data4 = 4'hE; data5 = 4'h0;

        #1;


        check_outputs(8'hEF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Subtraction (0 - 1) and MUX Selection 5", test_num);
        in1 = 4'h0;
        in2 = 4'h1;
        control = 1'b1;
        sel = 3'd5;
        data0 = 4'h0; data1 = 4'h0; data2 = 4'h0; data3 = 4'h0; data4 = 4'h0; data5 = 4'hF;

        #1;


        check_outputs(8'hFF);
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
