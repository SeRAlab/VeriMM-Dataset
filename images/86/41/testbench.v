`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] EN;
    reg aumento;
    reg clk;
    reg disminuye;
    reg rst;
    wire [3:0] cont_mes;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EN(EN),
        .aumento(aumento),
        .clk(clk),
        .disminuye(disminuye),
        .rst(rst),
        .cont_mes(cont_mes)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        EN = 2'b00;
        aumento = 0;
        disminuye = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        EN = 2'd1;
        aumento = 1;
        @(posedge clk);
        #1;
        aumento = 0;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        EN = 2'd1;
        aumento = 1; @(posedge clk);
        #1 aumento = 0; disminuye = 1;
        @(posedge clk);
        #1;
        disminuye = 0;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        EN = 2'd1;
        disminuye = 1;
        @(posedge clk);
        #1;
        disminuye = 0;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        EN = 2'd0;
        aumento = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase006;

    integer i;
    begin
        test_num = 6;
        reset_dut();
        EN = 2'd1;
        aumento = 1;
        for(i=0; i<11; i=i+1) begin
            @(posedge clk);
        end
        #1;
        aumento = 0;
        #1;

        check_outputs(4'd11);
    end
        endtask

    task testcase007;

    integer i;
    begin
        test_num = 7;
        reset_dut();
        EN = 2'd1;
        aumento = 1;

        for(i=0; i<12; i=i+1) begin
            @(posedge clk);
        end
        #1;
        aumento = 0;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();
        EN = 2'b11;
        aumento = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'd0);
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
        input [3:0] expected_cont_mes;
        begin
            if (expected_cont_mes === (expected_cont_mes ^ cont_mes ^ expected_cont_mes)) begin
                $display("PASS");
                $display("  Outputs: cont_mes=%h",
                         cont_mes);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cont_mes=%h",
                         expected_cont_mes);
                $display("  Got:      cont_mes=%h",
                         cont_mes);
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
        $dumpvars(0,EN, aumento, clk, disminuye, rst, cont_mes);
    end

endmodule
