`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg CLK;
    reg LOAD;
    reg clk;
    reg en;
    reg rst;
    reg up;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .CLK(CLK),
        .LOAD(LOAD),
        .clk(clk),
        .en(en),
        .rst(rst),
        .up(up),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        test_num = test_num + 1;
        $display("----------------------------------------");
        $display("Executing Testcase %03d", test_num);


        rst = 1;
        LOAD = 1;
        A = 4'b0000;
        en = 0;
        up = 0;

        @(posedge CLK);
        #1;
        rst = 0;
        LOAD = 0;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        A = 4'b1010;
        LOAD = 1;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(4'hA);
    end
        endtask

    task testcase002;

    begin
        reset_dut();

        A = 4'b0001;
        LOAD = 1;
        @(posedge CLK);
        #1;

        LOAD = 0;
        en = 1;
        up = 1;
        @(posedge CLK);
        #1;



        #1;




        check_outputs(4'h3);
    end
        endtask

    task testcase003;

    begin
        reset_dut();

        A = 4'b1000;
        LOAD = 1;
        @(posedge CLK);
        #1;

        LOAD = 0;
        en = 1;
        up = 0;
        @(posedge CLK);
        #1;



        #1;




        check_outputs(4'h0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();

        A = 4'b0111;
        LOAD = 1;
        @(posedge CLK);
        #1;

        LOAD = 0;
        en = 0;
        @(posedge CLK);
        #1;

        @(posedge CLK);
        #1;

        #1;


        check_outputs(4'hD);
    end
        endtask

    task testcase005;

    begin
        reset_dut();

        A = 4'b1111;
        LOAD = 1;
        en = 0;
        @(posedge CLK);
        #1;

        en = 1;
        up = 1;
        @(posedge CLK);
        #1;


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
        input [3:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,A, CLK, LOAD, clk, en, rst, up, q);
    end

endmodule
