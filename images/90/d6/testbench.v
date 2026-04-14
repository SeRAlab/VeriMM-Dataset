`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] adr;
    reg clk;
    reg [7:0] d_in;
    reg we;
    wire [7:0] d_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adr(adr),
        .clk(clk),
        .d_in(d_in),
        .we(we),
        .d_out(d_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        adr = 0;
        we = 0;
        d_in = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Write and Read", test_num);
        reset_dut();


        adr = 3'd0;
        d_in = 8'hA5;
        we = 1;
        @(posedge clk);
        #1;


        we = 0;
        #1;

        #1;


        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write to Address 7", test_num);
        reset_dut();


        adr = 3'd7;
        d_in = 8'h5A;
        we = 1;
        @(posedge clk);
        #1;


        we = 0;
        #1;

        #1;


        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify Write Enable signal", test_num);
        reset_dut();


        adr = 3'd2;
        d_in = 8'h12;
        we = 1;
        @(posedge clk);
        #1;


        d_in = 8'h34;
        we = 0;
        @(posedge clk);
        #1;


        #1;



        check_outputs(8'h12);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Overwrite existing register value", test_num);
        reset_dut();


        adr = 3'd4;
        d_in = 8'h11;
        we = 1;
        @(posedge clk);
        #1;


        d_in = 8'h22;
        @(posedge clk);
        #1;

        we = 0;
        #1;
        #1;

        check_outputs(8'h22);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Simultaneous Read/Write verification", test_num);
        reset_dut();

        adr = 3'd5;
        d_in = 8'hCC;
        we = 1;

        @(posedge clk);
        #1;

        #1;


        check_outputs(8'hCC);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiple register data persistence", test_num);
        reset_dut();


        adr = 3'd1; d_in = 8'h11; we = 1; @(posedge clk); #1;

        adr = 3'd6; d_in = 8'h66; we = 1; @(posedge clk); #1;


        we = 0;
        adr = 3'd1;
        #1;
        #1;

        check_outputs(8'h11);
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
        input [7:0] expected_d_out;
        begin
            if (expected_d_out === (expected_d_out ^ d_out ^ expected_d_out)) begin
                $display("PASS");
                $display("  Outputs: d_out=%h",
                         d_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_out=%h",
                         expected_d_out);
                $display("  Got:      d_out=%h",
                         d_out);
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
        $dumpvars(0,adr, clk, d_in, we, d_out);
    end

endmodule
