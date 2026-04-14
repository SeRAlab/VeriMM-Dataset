`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] Din0;
    reg [15:0] Din1;
    reg [15:0] Din2;
    reg [15:0] Din3;
    reg [15:0] Din4;
    reg [15:0] Din5;
    reg [15:0] Din6;
    reg [15:0] Din7;
    reg clk;
    reg rst_n;
    wire [15:0] Dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Din0(Din0),
        .Din1(Din1),
        .Din2(Din2),
        .Din3(Din3),
        .Din4(Din4),
        .Din5(Din5),
        .Din6(Din6),
        .Din7(Din7),
        .clk(clk),
        .rst_n(rst_n),
        .Dout(Dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        Din0 = 0; Din1 = 0; Din2 = 0; Din3 = 0;
        Din4 = 0; Din5 = 0; Din6 = 0; Din7 = 0;
        @(posedge clk);
        #2 rst_n = 1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        Din0 = 0; Din1 = 0; Din2 = 0; Din3 = 0;
        Din4 = 0; Din5 = 0; Din6 = 0; Din7 = 0;
        @(posedge clk);
        #2 #1;
 check_outputs(16'd23);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        Din0 = 1; Din1 = 2; Din2 = 3; Din3 = 4;
        Din4 = 5; Din5 = 6; Din6 = 7; Din7 = 8;
        @(posedge clk);
        #2 #1;
 check_outputs(16'd59);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        Din0 = -10; Din1 = -10; Din2 = -10; Din3 = -10;
        Din4 = -10; Din5 = -10; Din6 = -10; Din7 = -10;
        @(posedge clk);
        #2 #1;
 check_outputs(-16'd57);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        Din0 = 4000; Din1 = 4000; Din2 = 4000; Din3 = 4000;
        Din4 = 4000; Din5 = 4000; Din6 = 4000; Din7 = 4000;
        @(posedge clk);
        #2 #1;
 check_outputs(16'd32023);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        Din0 = 5000; Din1 = 5000; Din2 = 5000; Din3 = 5000;
        Din4 = 5000; Din5 = 5000; Din6 = 5000; Din7 = 5000;
        @(posedge clk);
        #2 #1;
 check_outputs(16'h9C57);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        Din0 = -5000; Din1 = -5000; Din2 = -5000; Din3 = -5000;
        Din4 = -5000; Din5 = -5000; Din6 = -5000; Din7 = -5000;
        @(posedge clk);
        #2 #1;
 check_outputs(16'h63D7);
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
        input [15:0] expected_Dout;
        begin
            if (expected_Dout === (expected_Dout ^ Dout ^ expected_Dout)) begin
                $display("PASS");
                $display("  Outputs: Dout=%h",
                         Dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Dout=%h",
                         expected_Dout);
                $display("  Got:      Dout=%h",
                         Dout);
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
        $dumpvars(0,Din0, Din1, Din2, Din3, Din4, Din5, Din6, Din7, clk, rst_n, Dout);
    end

endmodule
