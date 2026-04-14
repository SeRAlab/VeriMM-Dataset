`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [31:0] c;
    reg [1:0] sel;
    wire [31:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .sel(sel),
        .y(y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select Input A (sel = 00)", test_num);
        sel = 2'b00;
        a = 32'hAAAA_AAAA;
        b = 32'hBBBB_BBBB;
        c = 32'hCCCC_CCCC;
        #1;

        check_outputs(32'hAAAA_AAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select Input B (sel = 01)", test_num);
        sel = 2'b01;
        a = 32'h1234_5678;
        b = 32'h8765_4321;
        c = 32'hDEAD_BEEF;
        #1;

        check_outputs(32'h8765_4321);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select Input C (sel = 10)", test_num);
        sel = 2'b10;
        a = 32'h0000_0000;
        b = 32'hFFFF_FFFF;
        c = 32'h5555_5555;
        #1;

        check_outputs(32'h5555_5555);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input A with all ones (sel = 00)", test_num);
        sel = 2'b00;
        a = 32'hFFFF_FFFF;
        b = 32'h0000_0000;
        c = 32'h0000_0000;
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input B with mixed pattern (sel = 01)", test_num);
        sel = 2'b01;
        a = 32'hA5A5_A5A5;
        b = 32'h5A5A_5A5A;
        c = 32'hFFFF_0000;
        #1;

        check_outputs(32'h5A5A_5A5A);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input C with specific bit pattern (sel = 10)", test_num);
        sel = 2'b10;
        a = 32'h1111_1111;
        b = 32'h2222_2222;
        c = 32'h3333_3333;
        #1;

        check_outputs(32'h3333_3333);
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
        input [31:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
