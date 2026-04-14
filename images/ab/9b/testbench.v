`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] i2_com;
    reg i_com;
    reg i_seq;
    reg [127:0] wide_for_trace;
    reg [127:0] wide_for_trace_2;
    wire [1:0] o2_com;
    wire o_com;
    wire o_seq_d1r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .i2_com(i2_com),
        .i_com(i_com),
        .i_seq(i_seq),
        .wide_for_trace(wide_for_trace),
        .wide_for_trace_2(wide_for_trace_2),
        .o2_com(o2_com),
        .o_com(o_com),
        .o_seq_d1r(o_seq_d1r)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            i_seq = 0;
            i_com = 0;
            i2_com = 2'b00;
            wide_for_trace = 128'b0;
            wide_for_trace_2 = 128'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: All inputs low");
            reset_dut();
            test_num = 1;
            i_seq = 1'b0;
            i_com = 1'b0;
            i2_com = 2'b00;


            @(posedge clk);
            #2;


            #1;



            check_outputs(2'b11, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: All inputs high");
            reset_dut();
            test_num = 2;
            i_seq = 1'b1;
            i_com = 1'b1;
            i2_com = 2'b11;

            @(posedge clk);
            #2;


            #1;



            check_outputs(2'b00, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Alternating bit patterns");
            reset_dut();
            test_num = 3;
            i_seq = 1'b0;
            i_com = 1'b1;
            i2_com = 2'b10;

            @(posedge clk);
            #2;


            #1;



            check_outputs(2'b01, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Mixed pattern with tracing");
            reset_dut();
            test_num = 4;
            i_seq = 1'b1;
            i_com = 1'b0;
            i2_com = 2'b01;
            wide_for_trace = 128'hDEADBEEFCAFEBABE1234567887654321;
            wide_for_trace_2 = 128'hFFFFFFFFFFFFFFFF0000000000000000;

            @(posedge clk);
            #2;


            #1;



            check_outputs(2'b10, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Sequential change across cycles");
            reset_dut();
            test_num = 5;


            i_seq = 1'b1;
            @(posedge clk);
            #1;


            i_seq = 1'b0;
            i_com = 1'b1;
            i2_com = 2'b11;


            @(posedge clk);
            #2;



            #1;




            check_outputs(2'b00, 1'b0, 1'b1);
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
        input [1:0] expected_o2_com;
        input expected_o_com;
        input expected_o_seq_d1r;
        begin
            if (expected_o2_com === (expected_o2_com ^ o2_com ^ expected_o2_com) &&
                expected_o_com === (expected_o_com ^ o_com ^ expected_o_com) &&
                expected_o_seq_d1r === (expected_o_seq_d1r ^ o_seq_d1r ^ expected_o_seq_d1r)) begin
                $display("PASS");
                $display("  Outputs: o2_com=%h, o_com=%b, o_seq_d1r=%b",
                         o2_com, o_com, o_seq_d1r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o2_com=%h, o_com=%b, o_seq_d1r=%b",
                         expected_o2_com, expected_o_com, expected_o_seq_d1r);
                $display("  Got:      o2_com=%h, o_com=%b, o_seq_d1r=%b",
                         o2_com, o_com, o_seq_d1r);
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
        $dumpvars(0,clk, i2_com, i_com, i_seq, wide_for_trace, wide_for_trace_2, o2_com, o_com, o_seq_d1r);
    end

endmodule
