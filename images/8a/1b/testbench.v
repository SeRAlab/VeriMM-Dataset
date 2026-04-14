`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [3:0] data0;
    reg [3:0] data1;
    reg [3:0] data2;
    reg [3:0] data3;
    reg [3:0] data4;
    reg [3:0] data5;
    reg [2:0] sel;
    wire [6:0] final_out;
    wire o0;
    wire o1;
    wire o2;
    wire [2:0] out_3bit;
    wire [3:0] out_mux;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .data4(data4),
        .data5(data5),
        .sel(sel),
        .final_out(final_out),
        .o0(o0),
        .o1(o1),
        .o2(o2),
        .out_3bit(out_3bit),
        .out_mux(out_mux)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        sel = 3'd0;
        data0 = 4'd5; data1 = 4'd0; data2 = 4'd0; data3 = 4'd0; data4 = 4'd0; data5 = 4'd0;

        #1;


        check_outputs(7'd5, 1'b0, 1'b0, 1'b0, 3'd0, 4'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        sel = 3'd1;
        data0 = 4'd0; data1 = 4'd12; data2 = 4'd0; data3 = 4'd0; data4 = 4'd0; data5 = 4'd0;

        #1;


        check_outputs(7'd13, 1'b1, 1'b0, 1'b0, 3'd1, 4'd12);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        sel = 3'd2;
        data0 = 4'd0; data1 = 4'd0; data2 = 4'd7; data3 = 4'd0; data4 = 4'd0; data5 = 4'd0;

        #1;


        check_outputs(7'd9, 1'b0, 1'b1, 1'b0, 3'd2, 4'd7);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        sel = 3'd3;
        data0 = 4'd0; data1 = 4'd0; data2 = 4'd0; data3 = 4'd15; data4 = 4'd0; data5 = 4'd0;

        #1;


        check_outputs(7'd18, 1'b1, 1'b1, 1'b0, 3'd3, 4'd15);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        sel = 3'd4;
        data0 = 4'd0; data1 = 4'd0; data2 = 4'd0; data3 = 4'd0; data4 = 4'd2; data5 = 4'd0;

        #1;


        check_outputs(7'd6, 1'b0, 1'b0, 1'b1, 3'd4, 4'd2);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        sel = 3'd5;
        data0 = 4'd0; data1 = 4'd0; data2 = 4'd0; data3 = 4'd0; data4 = 4'd0; data5 = 4'd13;

        #1;


        check_outputs(7'd18, 1'b1, 1'b0, 1'b1, 3'd5, 4'd13);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        sel = 3'd0;
        data0 = 4'd15; data1 = 4'd0; data2 = 4'd0; data3 = 4'd0; data4 = 4'd0; data5 = 4'd0;

        #1;


        check_outputs(7'd15, 1'b0, 1'b0, 1'b0, 3'd0, 4'd15);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        sel = 3'd5;
        data0 = 4'd0; data1 = 4'd0; data2 = 4'd0; data3 = 4'd0; data4 = 4'd0; data5 = 4'd15;


        #1;



        check_outputs(7'd20, 1'b1, 1'b0, 1'b1, 3'd5, 4'd15);
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
        input [6:0] expected_final_out;
        input expected_o0;
        input expected_o1;
        input expected_o2;
        input [2:0] expected_out_3bit;
        input [3:0] expected_out_mux;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_final_out === (expected_final_out ^ final_out ^ expected_final_out) &&
                expected_o0 === (expected_o0 ^ o0 ^ expected_o0) &&
                expected_o1 === (expected_o1 ^ o1 ^ expected_o1) &&
                expected_o2 === (expected_o2 ^ o2 ^ expected_o2) &&
                expected_out_3bit === (expected_out_3bit ^ out_3bit ^ expected_out_3bit) &&
                expected_out_mux === (expected_out_mux ^ out_mux ^ expected_out_mux)) begin
                $display("PASS");
                $display("  Outputs: final_out=%h, o0=%b, o1=%b, o2=%b, out_3bit=%h, out_mux=%h",
                         final_out, o0, o1, o2, out_3bit, out_mux);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_out=%h, o0=%b, o1=%b, o2=%b, out_3bit=%h, out_mux=%h",
                         expected_final_out, expected_o0, expected_o1, expected_o2, expected_out_3bit, expected_out_mux);
                $display("  Got:      final_out=%h, o0=%b, o1=%b, o2=%b, out_3bit=%h, out_mux=%h",
                         final_out, o0, o1, o2, out_3bit, out_mux);
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
