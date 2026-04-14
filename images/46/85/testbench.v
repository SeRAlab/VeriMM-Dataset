`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [8:0] cpu_address;
    reg [7:0] cpu_data_in;
    reg [8:0] cur_address;
    reg hclk;
    reg pixclk;
    reg write;
    wire [7:0] cpu_data_out;
    wire [7:0] cur_data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cpu_address(cpu_address),
        .cpu_data_in(cpu_data_in),
        .cur_address(cur_address),
        .hclk(hclk),
        .pixclk(pixclk),
        .write(write),
        .cpu_data_out(cpu_data_out),
        .cur_data_out(cur_data_out)
    );

    // Clock generation (10ns period)
    initial begin
        hclk = 0;
        forever #5 hclk = ~hclk;
    end

        task reset_dut;

        begin
            write = 0;
            cpu_address = 0;
            cpu_data_in = 0;
            cur_address = 0;
            @(posedge hclk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            cpu_address = 9'h010;
            cpu_data_in = 8'hAA;
            write = 1;
            @(posedge hclk);
            #1;
            write = 0;



            #1;




            check_outputs(8'hAA, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            cpu_address = 9'h020;
            cpu_data_in = 8'h55;
            write = 1;
            @(posedge hclk);
            #1;


            write = 0;
            cur_address = 9'h020;
            @(posedge pixclk);
            #1;


            #1;



            check_outputs(8'h55, 8'h55);
        end
        endtask

    task testcase003;

        reg [7:0] initial_val;
        begin
            test_num = 3;
            reset_dut();


            cpu_address = 9'h005;
            cpu_data_in = 8'h11;
            write = 1;
            @(posedge hclk);
            #1;
            write = 0;
            cur_address = 9'h005;
            @(posedge pixclk);
            #1;
            initial_val = cur_data_out;



            cpu_address = 9'h006;
            cpu_data_in = 8'h22;
            write = 1;
            cur_address = 9'h006;

            repeat(2) @(posedge pixclk);
            #1;


            #1;



            check_outputs(8'h22, 8'h11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            cpu_address = 9'd511;
            cpu_data_in = 8'hEF;
            write = 1;
            @(posedge hclk);
            #1;
            write = 0;
            cur_address = 9'd511;
            @(posedge pixclk);
            #1;

            #1;


            check_outputs(8'hEF, 8'hEF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            cpu_address = 9'd100;
            cpu_data_in = 8'h12;
            write = 1;
            @(posedge hclk); #1;

            cpu_address = 9'd200;
            cpu_data_in = 8'h34;
            write = 1;
            @(posedge hclk); #1;

            write = 0;
            cpu_address = 9'd100;
            cur_address = 9'd200;
            @(posedge pixclk);
            #1;

            #1;


            check_outputs(8'h12, 8'h34);
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
        input [7:0] expected_cpu_data_out;
        input [7:0] expected_cur_data_out;
        begin
            if (expected_cpu_data_out === (expected_cpu_data_out ^ cpu_data_out ^ expected_cpu_data_out) &&
                expected_cur_data_out === (expected_cur_data_out ^ cur_data_out ^ expected_cur_data_out)) begin
                $display("PASS");
                $display("  Outputs: cpu_data_out=%h, cur_data_out=%h",
                         cpu_data_out, cur_data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cpu_data_out=%h, cur_data_out=%h",
                         expected_cpu_data_out, expected_cur_data_out);
                $display("  Got:      cpu_data_out=%h, cur_data_out=%h",
                         cpu_data_out, cur_data_out);
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
        $dumpvars(0,cpu_address, cpu_data_in, cur_address, hclk, pixclk, write, cpu_data_out, cur_data_out);
    end

endmodule
