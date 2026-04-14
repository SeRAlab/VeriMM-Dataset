`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [98:0] in0;
    reg [98:0] in1;
    reg [98:0] in2;
    reg [98:0] in3;
    reg [98:0] in4;
    reg [98:0] in5;
    reg [98:0] in6;
    reg sel0;
    reg sel1;
    reg sel2;
    reg sel3;
    reg sel4;
    reg sel5;
    reg sel6;
    wire [98:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .in5(in5),
        .in6(in6),
        .sel0(sel0),
        .sel1(sel1),
        .sel2(sel2),
        .sel3(sel3),
        .sel4(sel4),
        .sel5(sel5),
        .sel6(sel6),
        .out(out)
    );
    task clear_selects;

        begin
            sel0 = 0; sel1 = 0; sel2 = 0; sel3 = 0; sel4 = 0; sel5 = 0; sel6 = 0;
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        in0 = 99'h1111111111111111111111111;
        in1 = 99'h0; in2 = 99'h0; in3 = 99'h0; in4 = 99'h0; in5 = 99'h0; in6 = 99'h0;
        clear_selects();
        sel0 = 1;
        #1;

        check_outputs(in0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in1 = 99'h2222222222222222222222222;
        in0 = 99'h0; in2 = 99'h0; in3 = 99'h0; in4 = 99'h0; in5 = 99'h0; in6 = 99'h0;
        clear_selects();
        sel1 = 1;
        #1;

        check_outputs(in1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in2 = 99'h3333333333333333333333333;
        in0 = 99'h0; in1 = 99'h0; in3 = 99'h0; in4 = 99'h0; in5 = 99'h0; in6 = 99'h0;
        clear_selects();
        sel2 = 1;
        #1;

        check_outputs(in2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in3 = 99'h4444444444444444444444444;
        in0 = 99'h0; in1 = 99'h0; in2 = 99'h0; in4 = 99'h0; in5 = 99'h0; in6 = 99'h0;
        clear_selects();
        sel3 = 1;
        #1;

        check_outputs(in3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in4 = 99'h5555555555555555555555555;
        in0 = 99'h0; in1 = 99'h0; in2 = 99'h0; in3 = 99'h0; in5 = 99'h0; in6 = 99'h0;
        clear_selects();
        sel4 = 1;
        #1;

        check_outputs(in4);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in5 = 99'h6666666666666666666666666;
        in0 = 99'h0; in1 = 99'h0; in2 = 99'h0; in3 = 99'h0; in4 = 99'h0; in6 = 99'h0;
        clear_selects();
        sel5 = 1;
        #1;

        check_outputs(in5);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in6 = 99'h7777777777777777777777777;
        in0 = 99'h0; in1 = 99'h0; in2 = 99'h0; in3 = 99'h0; in4 = 99'h0; in5 = 99'h0;
        clear_selects();
        sel6 = 1;
        #1;

        check_outputs(in6);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in0 = 99'hAAA; in1 = 99'hBBB; in2 = 99'hCCC;
        clear_selects();
        #1;

        check_outputs(99'd0);
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
        input [98:0] expected_out;
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
