`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Ncpu_romsel;
    reg [3:0] cpu_d;
    reg cpu_rw;
    wire hc161_out0;
    wire hc161_out1;
    wire hc161_out2;
    wire hc161_out3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Ncpu_romsel(Ncpu_romsel),
        .cpu_d(cpu_d),
        .cpu_rw(cpu_rw),
        .hc161_out0(hc161_out0),
        .hc161_out1(hc161_out1),
        .hc161_out2(hc161_out2),
        .hc161_out3(hc161_out3)
    );

    // Clock generation (10ns period)
    initial begin
        Ncpu_romsel = 0;
        forever #5 Ncpu_romsel = ~Ncpu_romsel;
    end

        task reset_dut;

    begin
        cpu_rw = 0;
        cpu_d = 4'b0000;

        @(posedge Ncpu_romsel);
        #2;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("\nTestcase %0d: Basic Write (4'b1010)", test_num);
        cpu_rw = 0;
        cpu_d = 4'b1010;
        @(posedge Ncpu_romsel);
        #2;

        #1;


        check_outputs(0, 1, 0, 1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("\nTestcase %0d: Read Mode (Inhibit Write)", test_num);


        cpu_rw = 0;
        cpu_d = 4'b1111;
        @(posedge Ncpu_romsel);
        #2;


        cpu_rw = 1;
        cpu_d = 4'b0000;
        @(posedge Ncpu_romsel);
        #2;


        #1;



        check_outputs(1, 1, 1, 1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("\nTestcase %0d: Sequential All-Zeros and All-Ones", test_num);


        cpu_rw = 0;
        cpu_d = 4'b0000;
        @(posedge Ncpu_romsel);
        #2;


        cpu_d = 4'b1111;
        @(posedge Ncpu_romsel);
        #2;

        #1;


        check_outputs(1, 1, 1, 1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("\nTestcase %0d: Data stability between edges", test_num);

        cpu_rw = 0;
        cpu_d = 4'b0110;
        @(posedge Ncpu_romsel);
        #2;


        cpu_d = 4'b1111;
        #1;


        @(posedge Ncpu_romsel);
        #2;

        #1;


        check_outputs(1, 1, 1, 1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("\nTestcase %0d: Alternating bit pattern (0101)", test_num);

        cpu_rw = 0;
        cpu_d = 4'b0101;
        @(posedge Ncpu_romsel);
        #2;

        #1;


        check_outputs(1, 0, 1, 0);
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
        input expected_hc161_out0;
        input expected_hc161_out1;
        input expected_hc161_out2;
        input expected_hc161_out3;
        begin
            if (expected_hc161_out0 === (expected_hc161_out0 ^ hc161_out0 ^ expected_hc161_out0) &&
                expected_hc161_out1 === (expected_hc161_out1 ^ hc161_out1 ^ expected_hc161_out1) &&
                expected_hc161_out2 === (expected_hc161_out2 ^ hc161_out2 ^ expected_hc161_out2) &&
                expected_hc161_out3 === (expected_hc161_out3 ^ hc161_out3 ^ expected_hc161_out3)) begin
                $display("PASS");
                $display("  Outputs: hc161_out0=%b, hc161_out1=%b, hc161_out2=%b, hc161_out3=%b",
                         hc161_out0, hc161_out1, hc161_out2, hc161_out3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hc161_out0=%b, hc161_out1=%b, hc161_out2=%b, hc161_out3=%b",
                         expected_hc161_out0, expected_hc161_out1, expected_hc161_out2, expected_hc161_out3);
                $display("  Got:      hc161_out0=%b, hc161_out1=%b, hc161_out2=%b, hc161_out3=%b",
                         hc161_out0, hc161_out1, hc161_out2, hc161_out3);
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
        $dumpvars(0,Ncpu_romsel, cpu_d, cpu_rw, hc161_out0, hc161_out1, hc161_out2, hc161_out3);
    end

endmodule
