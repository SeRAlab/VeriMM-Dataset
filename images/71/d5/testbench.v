`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Cen;
    reg clk;
    reg initOne;
    reg rst;
    wire [7:0] Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Cen(Cen),
        .clk(clk),
        .initOne(initOne),
        .rst(rst),
        .Out(Out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        Cen = 0;
        initOne = 0;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task wait_cycles;

        input integer n;
        begin
            repeat(n) @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        reset_dut();


        #1;



        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        initOne = 1;
        @(posedge clk);
        #1 initOne = 0;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        Cen = 1;
        wait_cycles(10);
        Cen = 0;
        #1;

        check_outputs(8'd10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        Cen = 1;
        wait_cycles(5);
        Cen = 0;
        wait_cycles(5);
        #1;

        check_outputs(8'd5);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        rst = 1;
        initOne = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        initOne = 1;
        Cen = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(8'h01);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();

        initOne = 1;
        @(posedge clk);
        #1 initOne = 0; Cen = 1;
        wait_cycles(255);
        Cen = 0;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();
        Cen = 1;
        wait_cycles(20);
        initOne = 1;
        @(posedge clk);
        #1 initOne = 0;
        wait_cycles(19);
        #1;

        check_outputs(8'd20);
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
        input [7:0] expected_Out;
        begin
            if (expected_Out === (expected_Out ^ Out ^ expected_Out)) begin
                $display("PASS");
                $display("  Outputs: Out=%h",
                         Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out=%h",
                         expected_Out);
                $display("  Got:      Out=%h",
                         Out);
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
        $dumpvars(0,Cen, clk, initOne, rst, Out);
    end

endmodule
