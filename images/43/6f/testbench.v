`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg DOWN;
    reg LOAD;
    reg UP;
    reg [3:0] in;
    reg [1:0] shift_amt;
    wire [6:0] seg_display;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DOWN(DOWN),
        .LOAD(LOAD),
        .UP(UP),
        .in(in),
        .shift_amt(shift_amt),
        .seg_display(seg_display)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            UP = 0;
            DOWN = 0;
            LOAD = 1;
            in = 4'd0;
            shift_amt = 2'd0;
            @(posedge CLK);
            #1;
            LOAD = 0;
            $display("DUT Reset: Counter loaded with 0");
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Baseline zero check", test_num);

            #10;
            #1;

            check_outputs(7'h3f);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Load and add check", test_num);

            LOAD = 1; in = 4'd5; @(posedge CLK); #1; LOAD = 0;

            in = 4'd2; shift_amt = 2'd0;
            #10;
            #1;

            check_outputs(7'h07);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Increment check", test_num);

            LOAD = 1; in = 4'd1; @(posedge CLK); #1; LOAD = 0;

            UP = 1; @(posedge CLK); #1; UP = 0;

            in = 4'd0; shift_amt = 2'd0;
            #10;
            #1;

            check_outputs(7'h5b);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Decrement check", test_num);

            LOAD = 1; in = 4'd9; @(posedge CLK); #1; LOAD = 0;

            DOWN = 1; @(posedge CLK); #1; DOWN = 0;

            in = 4'd1; shift_amt = 2'd0;
            #10;
            #1;

            check_outputs(7'h6f);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Barrel shift left 1 check", test_num);

            LOAD = 1; in = 4'd2; @(posedge CLK); #1; LOAD = 0;

            in = 4'd1; shift_amt = 2'd1;
            #10;
            #1;

            check_outputs(7'h6d);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Barrel shift left 2 check", test_num);

            LOAD = 1; in = 4'd1; @(posedge CLK); #1; LOAD = 0;

            in = 4'd0; shift_amt = 2'd2;
            #10;
            #1;

            check_outputs(7'h66);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: UP, Shift, and Add combined", test_num);

            LOAD = 1; in = 4'd3; @(posedge CLK); #1; LOAD = 0;

            UP = 1; @(posedge CLK); #1; UP = 0;

            in = 4'd2; shift_amt = 2'd1;
            #10;
            #1;

            check_outputs(7'h77);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Hex display upper range check (D)", test_num);

            LOAD = 1; in = 4'd3; @(posedge CLK); #1; LOAD = 0;

            in = 4'd1; shift_amt = 2'd2;
            #10;
            #1;

            check_outputs(7'h5e);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Counter wrap-around check", test_num);

            LOAD = 1; in = 4'hf; @(posedge CLK); #1; LOAD = 0;

            UP = 1; @(posedge CLK); #1; UP = 0;

            in = 4'd11; shift_amt = 2'd0;
            #10;
            #1;

            check_outputs(7'h7c);
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
        input [6:0] expected_seg_display;
        begin
            if (expected_seg_display === (expected_seg_display ^ seg_display ^ expected_seg_display)) begin
                $display("PASS");
                $display("  Outputs: seg_display=%h",
                         seg_display);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seg_display=%h",
                         expected_seg_display);
                $display("  Got:      seg_display=%h",
                         seg_display);
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
        $dumpvars(0,CLK, DOWN, LOAD, UP, in, shift_amt, seg_display);
    end

endmodule
