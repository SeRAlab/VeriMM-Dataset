`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [14:0] addr;
    reg clk;
    reg cs;
    reg oe;
    reg we;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .cs(cs),
        .oe(oe),
        .we(we)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            cs = 0;
            we = 0;
            oe = 0;
            addr = 0;
            drive_data = 0;
            data_out_reg = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            @(posedge clk);
            addr = 15'h0001;
            data_out_reg = 8'hA5;
            drive_data = 1;
            cs = 1;
            we = 1;
            oe = 0;
            @(posedge clk);
            #1 we = 0; drive_data = 0;


            #1 oe = 1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            @(posedge clk);
            addr = 15'h0002;
            data_out_reg = 8'h5A;
            drive_data = 1;
            cs = 1;
            we = 1;
            @(posedge clk);
            #1 we = 0; drive_data = 0; oe = 0;


            #1;



            check_outputs(8'bz);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(posedge clk);
            addr = 15'h0003;
            cs = 1;
            we = 1;
            oe = 1;
            drive_data = 0;

            #1;


            check_outputs(8'bz);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            @(posedge clk);
            addr = 15'h0004;
            data_out_reg = 8'hFF;
            drive_data = 1;
            cs = 1;
            we = 1;
            @(posedge clk);
            #1 cs = 0; we = 0; drive_data = 0; oe = 1;

            #1;


            check_outputs(8'bz);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            @(posedge clk);
            addr = 15'h3FFF;
            data_out_reg = 8'h12;
            drive_data = 1;
            cs = 1;
            we = 1;
            @(posedge clk);
            #1 data_out_reg = 8'h34;
            @(posedge clk);
            #1 we = 0; drive_data = 0; oe = 1;

            #1;


            check_outputs(8'h34);
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
        $dumpvars(0,addr, clk, cs, oe, we);
    end

endmodule
