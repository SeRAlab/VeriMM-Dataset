`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLKDIV;
    reg dq0;
    reg dq1;
    reg dq2;
    reg dq3;
    reg rst;
    reg srint;
    wire SHO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLKDIV(CLKDIV),
        .dq0(dq0),
        .dq1(dq1),
        .dq2(dq2),
        .dq3(dq3),
        .rst(rst),
        .srint(srint),
        .SHO(SHO)
    );

    // Clock generation (10ns period)
    initial begin
        rst = 0;
        forever #5 rst = ~rst;
    end

        task reset_dut;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Resetting DUT", test_num);
        srint = 1;
        CLKDIV = 0;
        dq0 = 0; dq1 = 0; dq2 = 0; dq3 = 0;
        repeat(5) @(posedge rst);
        srint = 0;
        repeat(2) @(posedge rst);
    end
        endtask
    task testcase001;

    begin
        reset_dut();


        CLKDIV = 1;
        srint = 1;
        repeat(5) @(posedge rst);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();

        dq0 = 1;
        dq1 = 0;
        dq2 = 0;
        dq3 = 0;
        CLKDIV = 1;
        srint = 1;
        repeat(5) @(posedge rst);

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        dq0 = 1;
        CLKDIV = 0;
        srint = 1;
        repeat(10) @(posedge rst);

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        dq0 = 1;
        dq1 = 1;
        dq2 = 0;
        dq3 = 1;
        CLKDIV = 1;
        srint = 1;
        repeat(5) @(posedge rst);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();

        dq2 = 1;
        CLKDIV = 1;
        srint = 1;
        repeat(5) @(posedge rst);


        dq2 = 0;
        srint = 0;
        repeat(2) @(posedge rst);
        srint = 1;
        repeat(5) @(posedge rst);


        #1;



        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        dq3 = 1;
        CLKDIV = 1;
        srint = 0;
        repeat(10) @(posedge rst);

        #1;


        check_outputs(1'b0);
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
        input expected_SHO;
        begin
            if (expected_SHO === (expected_SHO ^ SHO ^ expected_SHO)) begin
                $display("PASS");
                $display("  Outputs: SHO=%b",
                         SHO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SHO=%b",
                         expected_SHO);
                $display("  Got:      SHO=%b",
                         SHO);
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
        $dumpvars(0,CLKDIV, dq0, dq1, dq2, dq3, rst, srint, SHO);
    end

endmodule
