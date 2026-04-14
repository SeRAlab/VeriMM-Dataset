`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] control;
    reg [31:0] input0;
    reg [31:0] input1;
    reg [31:0] input2;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .control(control),
        .input0(input0),
        .input1(input1),
        .input2(input2),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        input0 = 32'hAAAA_AAAA;
        input1 = 32'h5555_5555;
        input2 = 32'h1234_5678;
        control = 3'b000;
        #1;

        check_outputs(32'hAAAA_AAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        input0 = 32'hBBBB_BBBB;
        input1 = 32'h4444_4444;
        input2 = 32'h8765_4321;
        control = 3'b001;
        #1;

        check_outputs(32'hBBBB_BBBB);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        input0 = 32'h1111_1111;
        input1 = 32'h2222_2222;
        input2 = 32'h3333_3333;
        control = 3'b010;
        #1;

        check_outputs(32'h2222_2222);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        input0 = 32'hDEAD_BEEF;
        input1 = 32'hCAFE_BABE;
        input2 = 32'h0000_FFFF;
        control = 3'b011;
        #1;

        check_outputs(32'hCAFE_BABE);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        input0 = 32'hF0F0_F0F0;
        input1 = 32'h0F0F_0F0F;
        input2 = 32'hABCD_1234;
        control = 3'b100;
        #1;

        check_outputs(32'hABCD_1234);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        input0 = 32'h1234_0000;
        input1 = 32'h5678_0000;
        input2 = 32'h9ABC_DEF0;
        control = 3'b101;
        #1;

        check_outputs(32'h9ABC_DEF0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        input0 = 32'hFFFF_FFFF;
        input1 = 32'hFFFF_FFFF;
        input2 = 32'hFFFF_FFFF;
        control = 3'b110;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        input0 = 32'h1234_5678;
        input1 = 32'h9ABC_DEF0;
        input2 = 32'h0000_0000;
        control = 3'b111;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        input0 = 32'h0000_0000;
        input1 = 32'hFFFF_FFFF;
        input2 = 32'hFFFF_FFFF;
        control = 3'b000;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        input0 = 32'h0000_0000;
        input1 = 32'hFFFF_FFFF;
        input2 = 32'h0000_0000;
        control = 3'b010;
        #1;

        check_outputs(32'hFFFF_FFFF);
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
        input [31:0] expected_out;
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
