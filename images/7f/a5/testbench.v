`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg write_en;
    wire [7:0] data_out;
    wire err;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .write_en(write_en),
        .data_out(data_out),
        .err(err)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            write_en <= 0;
            data_in <= 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All Zeros Pattern", test_num);
            reset_dut();


            data_in <= 8'h00;
            write_en <= 1;
            @(posedge clk);


            write_en <= 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: All Ones Pattern", test_num);
            reset_dut();

            data_in <= 8'hFF;
            write_en <= 1;
            @(posedge clk);

            write_en <= 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hFF, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Alternating Bits 1010...", test_num);
            reset_dut();

            data_in <= 8'hAA;
            write_en <= 1;
            @(posedge clk);

            write_en <= 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hAA, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Alternating Bits 0101...", test_num);
            reset_dut();

            data_in <= 8'h55;
            write_en <= 1;
            @(posedge clk);

            write_en <= 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h55, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Data Stability Check", test_num);
            reset_dut();


            data_in <= 8'h12;
            write_en <= 1;
            @(posedge clk);


            data_in <= 8'h99;
            write_en <= 0;
            repeat (2) @(posedge clk);
            #1;


            #1;



            check_outputs(8'h12, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Single Bit Error Detection and Correction", test_num);
            reset_dut();


            data_in <= 8'hB4;
            write_en <= 1;
            @(posedge clk);
            write_en <= 0;
            @(posedge clk);




            force dut.data_out = dut.data_out ^ 8'h01;
            #1;



            #1;




            check_outputs(8'hB4, 1);

            release dut.data_out;
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
        input [7:0] expected_data_out;
        input expected_err;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_err === (expected_err ^ err ^ expected_err)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, err=%b",
                         data_out, err);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, err=%b",
                         expected_data_out, expected_err);
                $display("  Got:      data_out=%h, err=%b",
                         data_out, err);
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
        $dumpvars(0,clk, data_in, write_en, data_out, err);
    end

endmodule
