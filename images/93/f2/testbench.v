`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clk_ena;
    reg [7:0] d;
    reg rde;
    reg [7:0] read_address;
    reg we;
    reg [7:0] write_address;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clk_ena(clk_ena),
        .d(d),
        .rde(rde),
        .read_address(read_address),
        .we(we),
        .write_address(write_address),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clk_ena = 0;
            we = 0;
            rde = 0;
            d = 8'h00;
            write_address = 8'h00;
            read_address = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            clk_ena = 1;
            we = 1;
            write_address = 8'h10;
            d = 8'hA5;
            @(posedge clk);
            #1;
            we = 0;


            rde = 1;
            read_address = 8'h10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Clock Enable (Write Protection)", test_num);
            reset_dut();


            clk_ena = 1;
            we = 1;
            write_address = 8'h20;
            d = 8'h55;
            @(posedge clk);
            #1;


            clk_ena = 0;
            we = 1;
            d = 8'hAA;
            @(posedge clk);
            #1;


            clk_ena = 1;
            we = 0;
            rde = 1;
            read_address = 8'h20;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Clock Enable (Read Pumping)", test_num);
            reset_dut();


            clk_ena = 1;
            we = 1;
            write_address = 8'h30; d = 8'h11; @(posedge clk); #1;
            write_address = 8'h31; d = 8'h22; @(posedge clk); #1;
            we = 0;


            rde = 1;
            read_address = 8'h30;
            @(posedge clk);
            #1;


            clk_ena = 0;
            read_address = 8'h31;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Read Enable Control", test_num);
            reset_dut();


            clk_ena = 1;
            we = 1;
            write_address = 8'h40; d = 8'hCC; @(posedge clk); #1;


            we = 0;
            rde = 1;
            read_address = 8'h40;
            @(posedge clk);
            #1;


            rde = 0;
            read_address = 8'h00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Write Enable Control", test_num);
            reset_dut();


            clk_ena = 1;
            we = 1;
            write_address = 8'h50; d = 8'h77; @(posedge clk); #1;


            we = 0;
            d = 8'h88;
            @(posedge clk);
            #1;


            rde = 1;
            read_address = 8'h50;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h77);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Simultaneous Read and Write", test_num);
            reset_dut();


            clk_ena = 1;
            we = 1;
            write_address = 8'h60; d = 8'h12; @(posedge clk); #1;


            we = 1;
            write_address = 8'h70; d = 8'h34;
            rde = 1;
            read_address = 8'h60;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h12);


            we = 0;
            read_address = 8'h70;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h34);
            test_num = 6;
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, clk_ena, d, rde, read_address, we, write_address, q);
    end

endmodule
