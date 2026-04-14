`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg alrm;
    reg clk;
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
        alrm = 0; flag = 0; ser = 0; ta = 0; tb = 0;
        icrs = 0; data_in = 0; wr = 0;
        repeat(2) @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;

        #1;


        check_outputs(8'h00, 1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;

        icrs = 0; data_in = 8'h01; wr = 1; @(posedge clk); #1; wr = 0;

        ta = 1; @(posedge clk); #1; ta = 0;
        @(posedge clk);

        #1;


        check_outputs(8'h01, 1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;

        icrs = 0; data_in = 8'h02; wr = 1; @(posedge clk); #1; wr = 0;

        tb = 1; @(posedge clk); #1; tb = 0;
        @(posedge clk);
        #1;

        check_outputs(8'h02, 1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;

        icrs = 0; data_in = 8'h04; wr = 1; @(posedge clk); #1; wr = 0;
        alrm = 1; @(posedge clk); #1; alrm = 0;
        @(posedge clk);
        #1;

        check_outputs(8'h04, 1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;

        ta = 1; @(posedge clk); #1; ta = 0;
        @(posedge clk);

        #1;


        check_outputs(8'h00, 1'b0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;

        ta = 1; @(posedge clk); #1; ta = 0;
        tb = 1; @(posedge clk); #1; tb = 0;

        icrs = 1; wr = 0;
        @(posedge clk);

        #1;


        check_outputs(8'h03, 1'b0);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;

        icrs = 0; data_in = 8'h11; wr = 1; @(posedge clk); #1; wr = 0;

        ser = 1; @(posedge clk); #1; ser = 0;
        @(posedge clk);
        #1;

        check_outputs(8'h11, 1'b1);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = 8;

        icrs = 0; data_in = 8'h01; wr = 1; @(posedge clk); #1; wr = 0;
        ta = 1; @(posedge clk); #1; ta = 0;
        @(posedge clk);


        icrs = 1; data_in = 8'h00; wr = 1; @(posedge clk); #1; wr = 0;
        @(posedge clk);

        #1;


        check_outputs(8'h00, 1'b0);
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
        $dumpvars(0,alrm, clk, data_in, flag, icrs, reset, ser, ta, tb, wr, data_out, irq);
    end

endmodule
