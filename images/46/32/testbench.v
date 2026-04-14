`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RST;
    reg [63:0] inp;
    reg inp_valid;
    reg [31:0] lengthOutput;
    wire [63:0] out;
    wire out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RST(RST),
        .inp(inp),
        .inp_valid(inp_valid),
        .lengthOutput(lengthOutput),
        .out(out),
        .out_valid(out_valid)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RST = 1;
        inp = 0;
        inp_valid = 0;
        lengthOutput = 0;
        #20;
        RST = 0;
        @(posedge CLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Single Word Transmission", test_num);
        reset_dut();

        lengthOutput = 32'd1;
        inp = 64'hAAAA_AAAA_BBBB_BBBB;
        inp_valid = 1;
        @(posedge CLK);
        #1;
        inp_valid = 0;


        #1;



        check_outputs(64'hAAAA_AAAA_BBBB_BBBB, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Two-Word Continuous Transmission", test_num);
        reset_dut();

        lengthOutput = 32'd2;


        inp = 64'h1111_1111_1111_1111;
        inp_valid = 1;
        @(posedge CLK);
        #1;


        inp = 64'h2222_2222_2222_2222;
        inp_valid = 1;
        @(posedge CLK);
        #1;
        inp_valid = 0;


        #1;



        check_outputs(64'h2222_2222_2222_2222, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Transmission with Idle Gaps", test_num);
        reset_dut();

        lengthOutput = 32'd2;


        inp = 64'hCAFE_CAFE_CAFE_CAFE;
        inp_valid = 1;
        @(posedge CLK);
        #1;


        inp_valid = 0;
        @(posedge CLK);
        #1;


        inp = 64'hBABE_BABE_BABE_BABE;
        inp_valid = 1;
        @(posedge CLK);
        #1;
        inp_valid = 0;


        #1;



        check_outputs(64'hBABE_BABE_BABE_BABE, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Valid De-assertion check", test_num);
        reset_dut();

        lengthOutput = 32'd1;
        inp = 64'hEEEE_EEEE_EEEE_EEEE;
        inp_valid = 1;
        @(posedge CLK);
        #1;
        inp_valid = 0;


        @(posedge CLK);
        #1;
        #1;

        check_outputs(out, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Zero Length Transmission", test_num);
        reset_dut();

        lengthOutput = 32'd0;
        inp = 64'hFFFF_FFFF_FFFF_FFFF;
        inp_valid = 1;
        @(posedge CLK);
        #1;
        inp_valid = 0;


        #1;



        check_outputs(out, 1'b0);
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
        input [63:0] expected_out;
        input expected_out_valid;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_out_valid === (expected_out_valid ^ out_valid ^ expected_out_valid)) begin
                $display("PASS");
                $display("  Outputs: out=%h, out_valid=%b",
                         out, out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, out_valid=%b",
                         expected_out, expected_out_valid);
                $display("  Got:      out=%h, out_valid=%b",
                         out, out_valid);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,CLK, RST, inp, inp_valid, lengthOutput, out, out_valid);
    end

endmodule
