`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [14:0] data_in;
    reg [5:0] lz_pos;
    wire [14:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .lz_pos(lz_pos),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        data_in = 15'd0;
        lz_pos = 6'd0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        data_in = 15'h7FFF;
        lz_pos = 6'd0;
        @(posedge clk);
        #1;
        $display("Testcase %0d: All ones, lz_pos=0 (No mask)", test_num);
        #1;

        check_outputs(15'h7FFF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        data_in = 15'h7FFF;
        lz_pos = 6'd15;
        @(posedge clk);
        #1;
        $display("Testcase %0d: All ones, lz_pos=15 (Mask all)", test_num);
        #1;

        check_outputs(15'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        data_in = 15'h7FFF;
        lz_pos = 6'd1;
        @(posedge clk);
        #1;
        $display("Testcase %0d: All ones, lz_pos=1", test_num);
        #1;

        check_outputs(15'h7FFE);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();


        data_in = 15'h1234;
        lz_pos = 6'd4;
        @(posedge clk);
        #1;
        $display("Testcase %0d: data_in=0x1234, lz_pos=4", test_num);
        #1;

        check_outputs(15'h1640);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();


        data_in = 15'h4321;
        lz_pos = 6'd8;
        @(posedge clk);
        #1;
        $display("Testcase %0d: data_in=0x4321, lz_pos=8", test_num);
        #1;

        check_outputs(15'h4200);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();


        data_in = 15'h5555;
        lz_pos = 6'd7;
        @(posedge clk);
        #1;
        $display("Testcase %0d: data_in=0x5555, lz_pos=7", test_num);
        #1;

        check_outputs(15'h5580);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        data_in = 15'h7FFF;
        lz_pos = 6'd31;
        @(posedge clk);
        #1;
        $display("Testcase %0d: lz_pos=31 (Out of range)", test_num);
        #1;

        check_outputs(15'h0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();
        data_in = 15'h0000;
        lz_pos = 6'd0;
        @(posedge clk);
        #1;
        $display("Testcase %0d: data_in=0, lz_pos=0", test_num);
        #1;

        check_outputs(15'h0000);
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
        input [14:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, lz_pos, data_out);
    end

endmodule
