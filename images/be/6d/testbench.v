`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg Rst;
    reg [10:0] data_in;
    reg ld;
    reg ser_in;
    reg sh_en;
    wire ser_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .Rst(Rst),
        .data_in(data_in),
        .ld(ld),
        .ser_in(ser_in),
        .sh_en(sh_en),
        .ser_out(ser_out)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Rst = 1;
            ld = 0;
            sh_en = 0;
            data_in = 0;
            ser_in = 0;
            @(posedge Clk);
            #1 Rst = 0;
            @(posedge Clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            data_in = 11'b10101010101;
            ld = 1;
            @(posedge Clk);
            #1 ld = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data_in = 11'b10000000000;
            ld = 1;
            @(posedge Clk);
            #1 ld = 0;
            sh_en = 1;

            repeat(10) @(posedge Clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data_in = 11'b00000000000;
            ld = 1;
            @(posedge Clk);
            #1 ld = 0;
            ser_in = 1;
            sh_en = 1;

            repeat(11) @(posedge Clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data_in = 11'b11111111110;
            ld = 1;
            sh_en = 1;
            ser_in = 1;
            @(posedge Clk);
            #1;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            data_in = 11'b11111111111;
            ld = 1;
            @(posedge Clk);
            #1 ld = 0;

            Rst = 1;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            data_in = 11'b00000000010;
            ld = 1;
            @(posedge Clk);
            #1 ld = 0;
            sh_en = 0;
            @(posedge Clk);
            #1;

            #1;


            check_outputs(1'b0);
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
        input expected_ser_out;
        begin
            if (expected_ser_out === (expected_ser_out ^ ser_out ^ expected_ser_out)) begin
                $display("PASS");
                $display("  Outputs: ser_out=%b",
                         ser_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ser_out=%b",
                         expected_ser_out);
                $display("  Got:      ser_out=%b",
                         ser_out);
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
        $dumpvars(0,Clk, Rst, data_in, ld, ser_in, sh_en, ser_out);
    end

endmodule
