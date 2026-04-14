`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg drck1_i;
    reg reset_i;
    reg sel1_i;
    reg shift_i;
    reg tdi_i;
    wire [4:0] tdo1_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .drck1_i(drck1_i),
        .reset_i(reset_i),
        .sel1_i(sel1_i),
        .shift_i(shift_i),
        .tdi_i(tdi_i),
        .tdo1_o(tdo1_o)
    );

    // Clock generation (10ns period)
    initial begin
        drck1_i = 0;
        forever #5 drck1_i = ~drck1_i;
    end

        task reset_dut;

    begin
        reset_i = 1;
        drck1_i = 0;
        sel1_i = 0;
        shift_i = 0;
        tdi_i = 0;
        #10;
        reset_i = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset Behavior", test_num);
        reset_dut();

        #1;


        check_outputs(5'b00000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic Counting", test_num);
        reset_dut();

        repeat(5) @(posedge drck1_i);
        #1;
        #1;

        check_outputs(5'd5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Counter Wrap-around", test_num);
        reset_dut();
        repeat(32) @(posedge drck1_i);
        #1;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Serial Shift Input (10110)", test_num);
        reset_dut();
        sel1_i = 1;
        shift_i = 1;


        tdi_i = 1; @(posedge drck1_i);

        tdi_i = 0; @(posedge drck1_i);

        tdi_i = 1; @(posedge drck1_i);

        tdi_i = 1; @(posedge drck1_i);

        tdi_i = 0; @(posedge drck1_i);

        #1;

        #1;


        check_outputs(5'b10110);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Mode Switching (Count -> Shift)", test_num);
        reset_dut();


        repeat(3) @(posedge drck1_i);


        sel1_i = 1;
        shift_i = 1;
        tdi_i = 1;
        @(posedge drck1_i);

        #1;

        #1;


        check_outputs(5'd7);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Shift Control Dependency (sel=1, shift=0)", test_num);
        reset_dut();

        sel1_i = 1;
        shift_i = 0;
        tdi_i = 1;

        repeat(4) @(posedge drck1_i);

        #1;
        #1;

        check_outputs(5'd4);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Full Shift Fill", test_num);
        reset_dut();

        sel1_i = 1;
        shift_i = 1;
        tdi_i = 1;

        repeat(5) @(posedge drck1_i);

        #1;
        #1;

        check_outputs(5'b11111);
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
        input [4:0] expected_tdo1_o;
        begin
            if (expected_tdo1_o === (expected_tdo1_o ^ tdo1_o ^ expected_tdo1_o)) begin
                $display("PASS");
                $display("  Outputs: tdo1_o=%h",
                         tdo1_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tdo1_o=%h",
                         expected_tdo1_o);
                $display("  Got:      tdo1_o=%h",
                         tdo1_o);
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
        $dumpvars(0,drck1_i, reset_i, sel1_i, shift_i, tdi_i, tdo1_o);
    end

endmodule
