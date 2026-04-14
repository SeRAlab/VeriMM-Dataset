`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] in_vec;
    reg sel;
    wire o0;
    wire o1;
    wire o2;
    wire [2:0] out_vec;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_vec(in_vec),
        .sel(sel),
        .o0(o0),
        .o1(o1),
        .o2(o2),
        .out_vec(out_vec)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: in_vec=000, sel=0");
        in_vec = 3'b000;
        sel = 1'b0;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: in_vec=100, sel=0");
        in_vec = 3'b100;
        sel = 1'b0;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 3'b100);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: in_vec=010, sel=0");
        in_vec = 3'b010;
        sel = 1'b0;



        #1;




        check_outputs(1'b0, 1'b1, 1'b0, 3'b010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: in_vec=001, sel=0");
        in_vec = 3'b001;
        sel = 1'b0;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 3'b001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: in_vec=000, sel=1");
        in_vec = 3'b000;
        sel = 1'b1;
        #1;

        check_outputs(1'b0, 1'b0, 1'b0, 3'b000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: in_vec=100, sel=1");
        in_vec = 3'b100;
        sel = 1'b1;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 3'b100);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: in_vec=010, sel=1");
        in_vec = 3'b010;
        sel = 1'b1;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0, 3'b010);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: in_vec=111, sel=0");
        in_vec = 3'b111;
        sel = 1'b0;
        #1;

        check_outputs(1'b1, 1'b1, 1'b1, 3'b111);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 009: in_vec=111, sel=1");
        in_vec = 3'b111;
        sel = 1'b1;
        #1;

        check_outputs(1'b1, 1'b1, 1'b1, 3'b111);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case 010: in_vec=101, sel=0");
        in_vec = 3'b101;
        sel = 1'b0;
        #1;

        check_outputs(1'b1, 1'b0, 1'b1, 3'b101);
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
        input expected_o0;
        input expected_o1;
        input expected_o2;
        input [2:0] expected_out_vec;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o0 === (expected_o0 ^ o0 ^ expected_o0) &&
                expected_o1 === (expected_o1 ^ o1 ^ expected_o1) &&
                expected_o2 === (expected_o2 ^ o2 ^ expected_o2) &&
                expected_out_vec === (expected_out_vec ^ out_vec ^ expected_out_vec)) begin
                $display("PASS");
                $display("  Outputs: o0=%b, o1=%b, o2=%b, out_vec=%h",
                         o0, o1, o2, out_vec);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o0=%b, o1=%b, o2=%b, out_vec=%h",
                         expected_o0, expected_o1, expected_o2, expected_out_vec);
                $display("  Got:      o0=%b, o1=%b, o2=%b, out_vec=%h",
                         o0, o1, o2, out_vec);
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
