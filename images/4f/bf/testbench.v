`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg control;
    reg [31:0] in0;
    reg [31:0] in1;
    wire [31:0] mux_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .control(control),
        .in0(in0),
        .in1(in1),
        .mux_out(mux_out)
    );
    task testcase001;

    begin
        test_num = 1;
        in0 = 32'hAAAAAAAA;
        in1 = 32'h55555555;
        control = 0;
        $display("Test %0d: Select in0 (0xAAAAAAAA)", test_num);
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in0 = 32'hAAAAAAAA;
        in1 = 32'h55555555;
        control = 1;
        $display("Test %0d: Select in1 (0x55555555)", test_num);
        #1;

        check_outputs(32'h55555555);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in0 = 32'h00000000;
        in1 = 32'hFFFFFFFF;
        control = 0;
        $display("Test %0d: Select in0 (All Zeros)", test_num);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in0 = 32'h00000000;
        in1 = 32'hFFFFFFFF;
        control = 1;
        $display("Test %0d: Select in1 (All Ones)", test_num);
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in0 = 32'h12345678;
        in1 = 32'hFEDCBA98;
        control = 0;
        $display("Test %0d: Select in0 (Arbitrary Pattern)", test_num);
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in0 = 32'h12345678;
        in1 = 32'hFEDCBA98;
        control = 1;
        $display("Test %0d: Select in1 (Arbitrary Pattern)", test_num);
        #1;

        check_outputs(32'hFEDCBA98);
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
        input [31:0] expected_mux_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mux_out === (expected_mux_out ^ mux_out ^ expected_mux_out)) begin
                $display("PASS");
                $display("  Outputs: mux_out=%h",
                         mux_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mux_out=%h",
                         expected_mux_out);
                $display("  Got:      mux_out=%h",
                         mux_out);
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
