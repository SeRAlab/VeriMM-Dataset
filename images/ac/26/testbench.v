`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [13:0] c_addr;
    reg c_en;
    reg [13:0] d_addr;
    reg d_en;
    reg [13:0] i_addr;
    reg i_en;
    wire c_grnt;
    wire d_grnt;
    wire i_grnt;
    wire [1:0] muxcode;
    wire [13:0] o_addr;
    wire o_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c_addr(c_addr),
        .c_en(c_en),
        .d_addr(d_addr),
        .d_en(d_en),
        .i_addr(i_addr),
        .i_en(i_en),
        .c_grnt(c_grnt),
        .d_grnt(d_grnt),
        .i_grnt(i_grnt),
        .muxcode(muxcode),
        .o_addr(o_addr),
        .o_en(o_en)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All inputs inactive", test_num);
            i_en = 0; i_addr = 14'h0000;
            d_en = 0; d_addr = 14'h0000;
            c_en = 0; c_addr = 14'h0000;

            #1;


            check_outputs(0, 0, 0, 2'b00, 14'h0000, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Only i_en active", test_num);
            i_en = 1; i_addr = 14'h1AAA;
            d_en = 0; d_addr = 14'h2BBB;
            c_en = 0; c_addr = 14'h3CCC;

            #1;


            check_outputs(0, 0, 1, 2'b00, 14'h1AAA, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Only d_en active", test_num);
            i_en = 0; i_addr = 14'h1AAA;
            d_en = 1; d_addr = 14'h2BBB;
            c_en = 0; c_addr = 14'h3CCC;

            #1;


            check_outputs(0, 1, 0, 2'b01, 14'h2BBB, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Only c_en active", test_num);
            i_en = 0; i_addr = 14'h1AAA;
            d_en = 0; d_addr = 14'h2BBB;
            c_en = 1; c_addr = 14'h3CCC;

            #1;


            check_outputs(1, 0, 0, 2'b10, 14'h3CCC, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: i_en and d_en active (Priority check)", test_num);
            i_en = 1; i_addr = 14'h1111;
            d_en = 1; d_addr = 14'h2222;
            c_en = 0; c_addr = 14'h3333;

            #1;


            check_outputs(0, 0, 1, 2'b00, 14'h1111, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: d_en and c_en active (Priority check)", test_num);
            i_en = 0; i_addr = 14'h1111;
            d_en = 1; d_addr = 14'h2222;
            c_en = 1; c_addr = 14'h3333;

            #1;


            check_outputs(0, 1, 0, 2'b01, 14'h2222, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: i_en and c_en active (Priority check)", test_num);
            i_en = 1; i_addr = 14'h0FFF;
            d_en = 0; d_addr = 14'h0000;
            c_en = 1; c_addr = 14'h3FFF;

            #1;


            check_outputs(0, 0, 1, 2'b00, 14'h0FFF, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: All inputs active (Highest Priority check)", test_num);
            i_en = 1; i_addr = 14'h1234;
            d_en = 1; d_addr = 14'h2345;
            c_en = 1; c_addr = 14'h3456;

            #1;


            check_outputs(0, 0, 1, 2'b00, 14'h1234, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Address boundary check (c_en)", test_num);
            i_en = 0; i_addr = 14'h0000;
            d_en = 0; d_addr = 14'h0000;
            c_en = 1; c_addr = 14'h3FFF;

            #1;


            check_outputs(1, 0, 0, 2'b10, 14'h3FFF, 1);
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
        input expected_c_grnt;
        input expected_d_grnt;
        input expected_i_grnt;
        input [1:0] expected_muxcode;
        input [13:0] expected_o_addr;
        input expected_o_en;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c_grnt === (expected_c_grnt ^ c_grnt ^ expected_c_grnt) &&
                expected_d_grnt === (expected_d_grnt ^ d_grnt ^ expected_d_grnt) &&
                expected_i_grnt === (expected_i_grnt ^ i_grnt ^ expected_i_grnt) &&
                expected_muxcode === (expected_muxcode ^ muxcode ^ expected_muxcode) &&
                expected_o_addr === (expected_o_addr ^ o_addr ^ expected_o_addr) &&
                expected_o_en === (expected_o_en ^ o_en ^ expected_o_en)) begin
                $display("PASS");
                $display("  Outputs: c_grnt=%b, d_grnt=%b, i_grnt=%b, muxcode=%h, o_addr=%h, o_en=%b",
                         c_grnt, d_grnt, i_grnt, muxcode, o_addr, o_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c_grnt=%b, d_grnt=%b, i_grnt=%b, muxcode=%h, o_addr=%h, o_en=%b",
                         expected_c_grnt, expected_d_grnt, expected_i_grnt, expected_muxcode, expected_o_addr, expected_o_en);
                $display("  Got:      c_grnt=%b, d_grnt=%b, i_grnt=%b, muxcode=%h, o_addr=%h, o_en=%b",
                         c_grnt, d_grnt, i_grnt, muxcode, o_addr, o_en);
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
