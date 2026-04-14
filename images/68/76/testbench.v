`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [1:0] select;
    reg [3:0] sig_in;
    wire sig_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .select(select),
        .sig_in(sig_in),
        .sig_out(sig_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(negedge clk);
        reset = 1;
        @(negedge clk);
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Synchronous Reset", test_num);
        reset_dut();
        @(negedge clk);
        reset = 1;
        sig_in = 4'b1111;
        select = 2'b00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
        reset = 0;
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Select 0, sig_in[0]=0", test_num);
        reset_dut();
        @(negedge clk);
        select = 2'b00;
        sig_in = 4'b1110;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Select 0, sig_in[0]=1", test_num);
        reset_dut();
        @(negedge clk);
        select = 2'b00;
        sig_in = 4'b0001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Select 1, sig_in[1]=0", test_num);
        reset_dut();
        @(negedge clk);
        select = 2'b01;
        sig_in = 4'b1101;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Select 1, sig_in[1]=1", test_num);
        reset_dut();
        @(negedge clk);
        select = 2'b01;
        sig_in = 4'b0010;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Select 2, sig_in[2]=0", test_num);
        reset_dut();
        @(negedge clk);
        select = 2'b10;
        sig_in = 4'b1011;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Select 2, sig_in[2]=1", test_num);
        reset_dut();
        @(negedge clk);
        select = 2'b10;
        sig_in = 4'b0100;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Select 3, sig_in[3]=0", test_num);
        reset_dut();
        @(negedge clk);
        select = 2'b11;
        sig_in = 4'b0111;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Select 3, sig_in[3]=1", test_num);
        reset_dut();
        @(negedge clk);
        select = 2'b11;
        sig_in = 4'b1000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset Priority over data", test_num);
        reset_dut();
        @(negedge clk);
        select = 2'b11;
        sig_in = 4'b1000;
        reset = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
        reset = 0;
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
        testcase009();
        testcase010();
        
        
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
        input expected_sig_out;
        begin
            if (expected_sig_out === (expected_sig_out ^ sig_out ^ expected_sig_out)) begin
                $display("PASS");
                $display("  Outputs: sig_out=%b",
                         sig_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sig_out=%b",
                         expected_sig_out);
                $display("  Got:      sig_out=%b",
                         sig_out);
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
        $dumpvars(0,clk, reset, select, sig_in, sig_out);
    end

endmodule
