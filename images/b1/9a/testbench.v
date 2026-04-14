`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] E_st_data;
    reg [31:0] av_ld_data_aligned_filtered;
    reg clk;
    reg [22:0] d_address;
    reg d_read;
    reg d_waitrequest;
    reg d_write;
    reg debugack;
    reg reset_n;
    wire [22:0] cpu_d_address;
    wire cpu_d_read;
    wire [31:0] cpu_d_readdata;
    wire cpu_d_wait;
    wire cpu_d_write;
    wire [31:0] cpu_d_writedata;
    wire dbrk_break;
    wire dbrk_goto0;
    wire dbrk_goto1;
    wire dbrk_traceme;
    wire dbrk_traceoff;
    wire dbrk_traceon;
    wire dbrk_trigout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .E_st_data(E_st_data),
        .av_ld_data_aligned_filtered(av_ld_data_aligned_filtered),
        .clk(clk),
        .d_address(d_address),
        .d_read(d_read),
        .d_waitrequest(d_waitrequest),
        .d_write(d_write),
        .debugack(debugack),
        .reset_n(reset_n),
        .cpu_d_address(cpu_d_address),
        .cpu_d_read(cpu_d_read),
        .cpu_d_readdata(cpu_d_readdata),
        .cpu_d_wait(cpu_d_wait),
        .cpu_d_write(cpu_d_write),
        .cpu_d_writedata(cpu_d_writedata),
        .dbrk_break(dbrk_break),
        .dbrk_goto0(dbrk_goto0),
        .dbrk_goto1(dbrk_goto1),
        .dbrk_traceme(dbrk_traceme),
        .dbrk_traceoff(dbrk_traceoff),
        .dbrk_traceon(dbrk_traceon),
        .dbrk_trigout(dbrk_trigout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            E_st_data = 0;
            av_ld_data_aligned_filtered = 0;
            d_address = 0;
            d_read = 0;
            d_waitrequest = 0;
            d_write = 0;
            debugack = 0;
            repeat(2) @(posedge clk);
            #1 reset_n = 1;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(23'h0, 1'b0, 32'h0, 1'b0, 1'b0, 32'h0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            d_address = 23'h1A2B3C;
            d_read = 1'b1;
            av_ld_data_aligned_filtered = 32'hDEADBEEF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(23'h1A2B3C, 1'b1, 32'hDEADBEEF, 1'b0, 1'b0, 32'h0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            d_address = 23'h7FFFFF;
            d_write = 1'b1;
            E_st_data = 32'hCAFEBABE;
            @(posedge clk);
            #1;
            #1;

            check_outputs(23'h7FFFFF, 1'b0, 32'h0, 1'b0, 1'b1, 32'hCAFEBABE, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            d_waitrequest = 1'b1;
            d_read = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(23'h0, 1'b1, 32'h0, 1'b1, 1'b0, 32'h0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            debugack = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(23'h0, 1'b0, 32'h0, 1'b0, 1'b0, 32'h0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);

            @(posedge clk);
            debugack = 1'b0;
            #1;
            #1;

            check_outputs(23'h0, 1'b0, 32'h0, 1'b0, 1'b0, 32'h0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            d_address = 23'h000111;
            d_write = 1'b1;
            E_st_data = 32'h12345678;
            debugack = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(23'h000111, 1'b0, 32'h0, 1'b0, 1'b1, 32'h12345678, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
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
        input [22:0] expected_cpu_d_address;
        input expected_cpu_d_read;
        input [31:0] expected_cpu_d_readdata;
        input expected_cpu_d_wait;
        input expected_cpu_d_write;
        input [31:0] expected_cpu_d_writedata;
        input expected_dbrk_break;
        input expected_dbrk_goto0;
        input expected_dbrk_goto1;
        input expected_dbrk_traceme;
        input expected_dbrk_traceoff;
        input expected_dbrk_traceon;
        input expected_dbrk_trigout;
        begin
            if (expected_cpu_d_address === (expected_cpu_d_address ^ cpu_d_address ^ expected_cpu_d_address) &&
                expected_cpu_d_read === (expected_cpu_d_read ^ cpu_d_read ^ expected_cpu_d_read) &&
                expected_cpu_d_readdata === (expected_cpu_d_readdata ^ cpu_d_readdata ^ expected_cpu_d_readdata) &&
                expected_cpu_d_wait === (expected_cpu_d_wait ^ cpu_d_wait ^ expected_cpu_d_wait) &&
                expected_cpu_d_write === (expected_cpu_d_write ^ cpu_d_write ^ expected_cpu_d_write) &&
                expected_cpu_d_writedata === (expected_cpu_d_writedata ^ cpu_d_writedata ^ expected_cpu_d_writedata) &&
                expected_dbrk_break === (expected_dbrk_break ^ dbrk_break ^ expected_dbrk_break) &&
                expected_dbrk_goto0 === (expected_dbrk_goto0 ^ dbrk_goto0 ^ expected_dbrk_goto0) &&
                expected_dbrk_goto1 === (expected_dbrk_goto1 ^ dbrk_goto1 ^ expected_dbrk_goto1) &&
                expected_dbrk_traceme === (expected_dbrk_traceme ^ dbrk_traceme ^ expected_dbrk_traceme) &&
                expected_dbrk_traceoff === (expected_dbrk_traceoff ^ dbrk_traceoff ^ expected_dbrk_traceoff) &&
                expected_dbrk_traceon === (expected_dbrk_traceon ^ dbrk_traceon ^ expected_dbrk_traceon) &&
                expected_dbrk_trigout === (expected_dbrk_trigout ^ dbrk_trigout ^ expected_dbrk_trigout)) begin
                $display("PASS");
                $display("  Outputs: cpu_d_address=%h, cpu_d_read=%b, cpu_d_readdata=%h, cpu_d_wait=%b, cpu_d_write=%b, cpu_d_writedata=%h, dbrk_break=%b, dbrk_goto0=%b, dbrk_goto1=%b, dbrk_traceme=%b, dbrk_traceoff=%b, dbrk_traceon=%b, dbrk_trigout=%b",
                         cpu_d_address, cpu_d_read, cpu_d_readdata, cpu_d_wait, cpu_d_write, cpu_d_writedata, dbrk_break, dbrk_goto0, dbrk_goto1, dbrk_traceme, dbrk_traceoff, dbrk_traceon, dbrk_trigout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cpu_d_address=%h, cpu_d_read=%b, cpu_d_readdata=%h, cpu_d_wait=%b, cpu_d_write=%b, cpu_d_writedata=%h, dbrk_break=%b, dbrk_goto0=%b, dbrk_goto1=%b, dbrk_traceme=%b, dbrk_traceoff=%b, dbrk_traceon=%b, dbrk_trigout=%b",
                         expected_cpu_d_address, expected_cpu_d_read, expected_cpu_d_readdata, expected_cpu_d_wait, expected_cpu_d_write, expected_cpu_d_writedata, expected_dbrk_break, expected_dbrk_goto0, expected_dbrk_goto1, expected_dbrk_traceme, expected_dbrk_traceoff, expected_dbrk_traceon, expected_dbrk_trigout);
                $display("  Got:      cpu_d_address=%h, cpu_d_read=%b, cpu_d_readdata=%h, cpu_d_wait=%b, cpu_d_write=%b, cpu_d_writedata=%h, dbrk_break=%b, dbrk_goto0=%b, dbrk_goto1=%b, dbrk_traceme=%b, dbrk_traceoff=%b, dbrk_traceon=%b, dbrk_trigout=%b",
                         cpu_d_address, cpu_d_read, cpu_d_readdata, cpu_d_wait, cpu_d_write, cpu_d_writedata, dbrk_break, dbrk_goto0, dbrk_goto1, dbrk_traceme, dbrk_traceoff, dbrk_traceon, dbrk_trigout);
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
        $dumpvars(0,E_st_data, av_ld_data_aligned_filtered, clk, d_address, d_read, d_waitrequest, d_write, debugack, reset_n, cpu_d_address, cpu_d_read, cpu_d_readdata, cpu_d_wait, cpu_d_write, cpu_d_writedata, dbrk_break, dbrk_goto0, dbrk_goto1, dbrk_traceme, dbrk_traceoff, dbrk_traceon, dbrk_trigout);
    end

endmodule
