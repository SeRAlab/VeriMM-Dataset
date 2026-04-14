`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [13:0] in;
    wire [12:0] out_and;
    wire [12:0] out_or;
    wire [13:0] out_xnor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_and(out_and),
        .out_or(out_or),
        .out_xnor(out_xnor)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        in = 14'h0000;
        $display("Test Case %0d: in = %h (All Zeros)", test_num, in);

        #1;


        check_outputs(13'h0000, 13'h0000, 14'h3FFF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        in = 14'h3FFF;
        $display("Test Case %0d: in = %h (All Ones)", test_num, in);

        #1;


        check_outputs(13'h1FFF, 13'h1FFF, 14'h3FFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        in = 14'h2AAA;
        $display("Test Case %0d: in = %h (Alternating 10)", test_num, in);

        #1;


        check_outputs(13'h0000, 13'h1FFF, 14'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        in = 14'h1555;
        $display("Test Case %0d: in = %h (Alternating 01)", test_num, in);

        #1;


        check_outputs(13'h0000, 13'h1FFF, 14'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        in = 14'h0001;
        $display("Test Case %0d: in = %h (Single Bit 0)", test_num, in);

        #1;


        check_outputs(13'h0000, 13'h0001, 14'h1FFE);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        in = 14'h2000;
        $display("Test Case %0d: in = %h (Single Bit 13)", test_num, in);

        #1;


        check_outputs(13'h0000, 13'h1000, 14'h0FFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        in = 14'h1A3C;
        $display("Test Case %0d: in = %h (Random Pattern)", test_num, in);

        #1;


        check_outputs(13'h081C, 13'h1F3E, 14'h28DD);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        in = 14'h03F0;
        $display("Test Case %0d: in = %h (Block Pattern)", test_num, in);

        #1;


        check_outputs(13'h01F0, 13'h03F8, 14'h3DF7);
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
        input [12:0] expected_out_and;
        input [12:0] expected_out_or;
        input [13:0] expected_out_xnor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_or === (expected_out_or ^ out_or ^ expected_out_or) &&
                expected_out_xnor === (expected_out_xnor ^ out_xnor ^ expected_out_xnor)) begin
                $display("PASS");
                $display("  Outputs: out_and=%h, out_or=%h, out_xnor=%h",
                         out_and, out_or, out_xnor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and=%h, out_or=%h, out_xnor=%h",
                         expected_out_and, expected_out_or, expected_out_xnor);
                $display("  Got:      out_and=%h, out_or=%h, out_xnor=%h",
                         out_and, out_or, out_xnor);
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
