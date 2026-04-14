`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] address;
    reg clk;
    reg out_en;
    reg rd_en;
    reg wr_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .out_en(out_en),
        .rd_en(rd_en),
        .wr_en(wr_en)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            address = 0;
            out_en = 0;
            rd_en = 0;
            wr_en = 0;
            drive_en = 0;
            data_drive = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            address = 4'h0;
            data_drive = 8'hAA;
            drive_en = 1;
            wr_en = 1;
            @(posedge clk);
            #1;
            wr_en = 0;
            drive_en = 0;


            rd_en = 1;
            @(posedge clk);
            #1;
            rd_en = 0;
            out_en = 1;
            #1;
            #1;

            check_outputs(8'hAA, 0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            address = 4'h5;
            data_drive = 8'h55;
            drive_en = 1;
            wr_en = 1;
            @(posedge clk);
            #1;
            wr_en = 0;
            drive_en = 0;


            rd_en = 1;
            @(posedge clk);
            #1;
            rd_en = 0;
            out_en = 0;
            #1;
            #1;

            check_outputs(8'hXX, 1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            address = 4'hF;
            data_drive = 8'hFF;
            drive_en = 1;
            wr_en = 1;
            @(posedge clk);
            #1;
            wr_en = 0;
            drive_en = 0;


            rd_en = 1;
            @(posedge clk);
            #1;
            rd_en = 0;
            out_en = 1;
            #1;
            #1;

            check_outputs(8'hFF, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            address = 4'hA;
            data_drive = 8'h12;
            drive_en = 1;
            wr_en = 1;
            @(posedge clk);
            #1;

            data_drive = 8'h34;
            @(posedge clk);
            #1;
            wr_en = 0;
            drive_en = 0;


            rd_en = 1;
            @(posedge clk);
            #1;
            rd_en = 0;
            out_en = 1;
            #1;
            #1;

            check_outputs(8'h34, 0);
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
        begin
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
        $dumpvars(0,address, clk, out_en, rd_en, wr_en);
    end

endmodule
