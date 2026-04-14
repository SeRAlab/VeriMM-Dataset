`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg alrm;
    reg clk;
    reg clk7_en;
    reg [7:0] data_in;
    reg flag;
    reg icrs;
    reg reset;
    reg ser;
    reg ta;
    reg tb;
    reg wr;
    wire [7:0] data_out;
    wire irq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alrm(alrm),
        .clk(clk),
        .clk7_en(clk7_en),
        .data_in(data_in),
        .flag(flag),
        .icrs(icrs),
        .reset(reset),
        .ser(ser),
        .ta(ta),
        .tb(tb),
        .wr(wr),
        .data_out(data_out),
        .irq(irq)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        wr = 0;
        icrs = 0;
        clk7_en = 0;
        ta = 0;
        tb = 0;
        alrm = 0;
        flag = 0;
        ser = 0;
        data_in = 8'h00;
        repeat (2) @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        $display("Testcase 001: Checking Reset State");

        icrs = 1; wr = 0; clk7_en = 1;
        repeat (2) @(posedge clk);
        #1;

        check_outputs(8'h00, 1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        $display("Testcase 002: Enable 'ta' and trigger");

        @(posedge clk);
        clk7_en = 1; icrs = 1; wr = 1;
        data_in = 8'h01;
        @(posedge clk);
        wr = 0;

        ta = 1;
        repeat (2) @(posedge clk);


        #1;



        check_outputs(8'h01, 1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        $display("Testcase 003: Trigger 'tb' with mask disabled");

        @(posedge clk);
        clk7_en = 1; icrs = 1; wr = 1;
        data_in = 8'h01;
        @(posedge clk);
        wr = 0;

        tb = 1;
        repeat (2) @(posedge clk);


        #1;



        check_outputs(8'h02, 1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        $display("Testcase 004: Multiple interrupts with mixed mask");

        @(posedge clk);
        clk7_en = 1; icrs = 1; wr = 1;
        data_in = 8'h0C;
        @(posedge clk);
        wr = 0;

        alrm = 1;
        flag = 1;
        repeat (2) @(posedge clk);


        #1;



        check_outputs(8'h14, 1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        $display("Testcase 005: Trigger all, mask none");

        @(posedge clk);
        clk7_en = 1; icrs = 1; wr = 1;
        data_in = 8'h00;
        @(posedge clk);
        wr = 0;

        ta = 1; tb = 1; alrm = 1; ser = 1; flag = 1;
        repeat (2) @(posedge clk);

        #1;


        check_outputs(8'h1F, 1'b0);
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
        input [7:0] expected_data_out;
        input expected_irq;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_irq === (expected_irq ^ irq ^ expected_irq)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, irq=%b",
                         data_out, irq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, irq=%b",
                         expected_data_out, expected_irq);
                $display("  Got:      data_out=%h, irq=%b",
                         data_out, irq);
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
        $dumpvars(0,alrm, clk, clk7_en, data_in, flag, icrs, reset, ser, ta, tb, wr, data_out, irq);
    end

endmodule
