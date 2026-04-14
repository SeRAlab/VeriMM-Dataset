`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] w_bus_addr;
    reg w_clock;
    reg w_reset;
    reg w_write_enable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .w_bus_addr(w_bus_addr),
        .w_clock(w_clock),
        .w_reset(w_reset),
        .w_write_enable(w_write_enable)
    );

    // Clock generation (10ns period)
    initial begin
        w_clock = 0;
        forever #5 w_clock = ~w_clock;
    end

        task reset_dut;

        begin
            w_reset = 1;
            w_write_enable = 0;
            w_bus_addr = 0;
            data_to_drive = 0;
            @(posedge w_clock);
            #1;
            w_reset = 0;
            @(posedge w_clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            w_bus_addr = 8'h10;
            data_to_drive = 8'h5A;
            w_write_enable = 1;
            @(posedge w_clock);
            #1;

            w_write_enable = 0;
            @(posedge w_clock);
            #1;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            w_bus_addr = 8'hFF;
            data_to_drive = 8'hFF;
            w_write_enable = 1;
            @(posedge w_clock);
            #1;

            w_write_enable = 0;
            @(posedge w_clock);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            w_bus_addr = 8'h20;
            data_to_drive = 8'hAA;
            w_write_enable = 1;
            @(posedge w_clock);
            #1;

            w_reset = 1;
            @(posedge w_clock);
            #1;
            w_reset = 0;
            w_write_enable = 0;
            w_bus_addr = 8'h20;
            @(posedge w_clock);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            w_bus_addr = 8'h30;
            data_to_drive = 8'h11;
            w_write_enable = 1;
            @(posedge w_clock);
            #1;

            data_to_drive = 8'h22;
            @(posedge w_clock);
            #1;

            w_write_enable = 0;
            @(posedge w_clock);
            #1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            w_bus_addr = 8'h01;
            data_to_drive = 8'hCC;
            w_write_enable = 1;
            @(posedge w_clock);
            #1;

            w_bus_addr = 8'h02;
            data_to_drive = 8'hDD;
            w_write_enable = 1;
            @(posedge w_clock);
            #1;

            w_write_enable = 0;
            w_bus_addr = 8'h01;
            @(posedge w_clock);
            #1;
            #1;

            check_outputs(8'hCC);
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
        $dumpvars(0,w_bus_addr, w_clock, w_reset, w_write_enable);
    end

endmodule
