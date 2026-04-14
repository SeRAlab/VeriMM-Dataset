`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg [5:0] read_addr;
    reg we;
    reg [5:0] write_addr;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .read_addr(read_addr),
        .we(we),
        .write_addr(write_addr),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            data = 0;
            read_addr = 0;
            write_addr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            we = 1;
            write_addr = 6'd10;
            data = 8'hA5;
            @(posedge clk);
            #1;


            we = 0;
            read_addr = 6'd10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            we = 1;
            write_addr = 6'd0;
            data = 8'h55;
            @(posedge clk);
            #1;


            write_addr = 6'd63;
            data = 8'hAA;
            @(posedge clk);
            #1;


            we = 0;
            read_addr = 6'd63;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            we = 1;
            write_addr = 6'd5;
            data = 8'hFF;
            @(posedge clk);
            #1;


            we = 0;
            write_addr = 6'd5;
            data = 8'h00;
            @(posedge clk);
            #1;


            read_addr = 6'd5;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            we = 1;
            write_addr = 6'd20;
            data = 8'h12;
            @(posedge clk);
            #1;


            we = 1;
            write_addr = 6'd21;
            data = 8'h34;
            read_addr = 6'd20;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h12);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            reset_dut();


            we = 1;
            for(i = 0; i < 8; i = i + 1) begin
                write_addr = i;
                data = i;
                @(posedge clk);
                #1;
            end


            we = 0;
            read_addr = 6'd7;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h07);
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
        $dumpvars(0,clk, data, read_addr, we, write_addr, q);
    end

endmodule
