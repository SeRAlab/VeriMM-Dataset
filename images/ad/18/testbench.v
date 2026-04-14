`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] a;
    reg [11:0] b;
    reg [11:0] c;
    reg [11:0] d;
    reg [1:0] sel;
    wire [11:0] out;

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
        .sel(sel),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 12'hAAA; b = 12'hBBB; c = 12'hCCC; d = 12'hDDD;
        sel = 2'b00;
        $display("Test %0d: Select a (sel=00)", test_num);
        #1;

        check_outputs(12'hAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 12'hAAA; b = 12'hBBB; c = 12'hCCC; d = 12'hDDD;
        sel = 2'b01;
        $display("Test %0d: Select b (sel=01)", test_num);
        #1;

        check_outputs(12'hBBB);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 12'hAAA; b = 12'hBBB; c = 12'hCCC; d = 12'hDDD;
        sel = 2'b10;
        $display("Test %0d: Select c (sel=10)", test_num);
        #1;

        check_outputs(12'hCCC);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 12'hAAA; b = 12'hBBB; c = 12'hCCC; d = 12'hDDD;
        sel = 2'b11;
        $display("Test %0d: Select d (sel=11)", test_num);
        #1;

        check_outputs(12'hDDD);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 12'hFFF; b = 12'h000; c = 12'h555; d = 12'hAAA;
        sel = 2'b00;
        $display("Test %0d: All ones on input a (sel=00)", test_num);
        #1;

        check_outputs(12'hFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 12'hFFF; b = 12'h000; c = 12'h555; d = 12'hAAA;
        sel = 2'b01;
        $display("Test %0d: All zeros on input b (sel=01)", test_num);
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 12'h123; b = 12'h456; c = 12'h789; d = 12'hABC;
        sel = 2'b10;
        $display("Test %0d: Arbitrary value on input c (sel=10)", test_num);
        #1;

        check_outputs(12'h789);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 12'h001; b = 12'h002; c = 12'h004; d = 12'h008;
        sel = 2'b11;
        $display("Test %0d: LSB check on input d (sel=11)", test_num);
        #1;

        check_outputs(12'h008);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 12'h800; b = 12'h400; c = 12'h200; d = 12'h100;
        sel = 2'b00;
        $display("Test %0d: MSB check on input a (sel=00)", test_num);
        #1;

        check_outputs(12'h800);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 12'h5AA; b = 12'h5AA; c = 12'h5AA; d = 12'h5AA;
        sel = 2'b10;
        $display("Test %0d: All inputs identical (sel=10)", test_num);
        #1;

        check_outputs(12'h5AA);
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
        input [11:0] expected_out;
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
