`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg en;
    reg [3:0] in0;
    reg [3:0] in1;
    reg [3:0] in2;
    reg [3:0] in3;
    reg [1:0] sel;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .en(en),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .sel(sel),
        .out(out)
    );
    task reset_signals;

        begin
            en  = 0;
            sel = 0;
            in0 = 0;
            in1 = 0;
            in2 = 0;
            in3 = 0;
            #5;
        end
        endtask

    task testcase001;

        begin
            reset_signals();
            test_num = test_num + 1;
            $display("Testcase %0d: en=0, sel=0, in0=0xA. Expect out=0.", test_num);
            in0 = 4'hA;
            sel = 2'b00;
            en  = 1'b0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            reset_signals();
            test_num = test_num + 1;
            $display("Testcase %0d: en=0, sel=3, in3=0xF. Expect out=0.", test_num);
            in3 = 4'hF;
            sel = 2'b11;
            en  = 1'b0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase003;

        begin
            reset_signals();
            test_num = test_num + 1;
            $display("Testcase %0d: en=1, sel=0, in0=0x5. Expect out=0x5.", test_num);
            in0 = 4'h5;
            sel = 2'b00;
            en  = 1'b1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase004;

        begin
            reset_signals();
            test_num = test_num + 1;
            $display("Testcase %0d: en=1, sel=1, in1=0xE. Expect out=0xE.", test_num);
            in1 = 4'hE;
            sel = 2'b01;
            en  = 1'b1;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase005;

        begin
            reset_signals();
            test_num = test_num + 1;
            $display("Testcase %0d: en=1, sel=2, in2=4'h7. Expect out=0x7.", test_num);
            in2 = 4'h7;
            sel = 2'b10;
            en  = 1'b1;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase006;

        begin
            reset_signals();
            test_num = test_num + 1;
            $display("Testcase %0d: en=1, sel=3, in3=4'h2. Expect out=0x2.", test_num);
            in3 = 4'h2;
            sel = 2'b11;
            en  = 1'b1;
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase007;

        begin
            reset_signals();
            test_num = test_num + 1;
            $display("Testcase %0d: Dynamic en toggle, sel=0, in0=0xC. Expect out=0x0.", test_num);
            in0 = 4'hC;
            sel = 2'b00;
            en  = 1'b1;
            #5;
            en  = 1'b0;
            #1;

            check_outputs(4'h0);
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
        input [3:0] expected_out;
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
