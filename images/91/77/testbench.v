`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] add_bus;
    reg clock;
    reg rw;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .add_bus(add_bus),
        .clock(clock),
        .rw(rw)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            rw = 1;
            add_bus = 16'h0;
            tb_drive_data = 8'h0;
            @(posedge clock);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            add_bus = 16'h0010;
            tb_drive_data = 8'hA5;
            rw = 0;
            @(posedge clock);
            #2;

            rw = 1;
            add_bus = 16'h0010;
            #5;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            add_bus = 16'h0000;
            tb_drive_data = 8'hFF;
            rw = 0;
            @(posedge clock);
            #2;

            rw = 1;
            add_bus = 16'h0000;
            #5;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            add_bus = 16'h1FFF;
            tb_drive_data = 8'h55;
            rw = 0;
            @(posedge clock);
            #2;

            rw = 1;
            add_bus = 16'h1FFF;
            #5;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            add_bus = 16'h0ABC;
            tb_drive_data = 8'h11;
            rw = 0;
            @(posedge clock);
            #5;

            tb_drive_data = 8'h22;
            @(posedge clock);
            #2;

            rw = 1;
            add_bus = 16'h0ABC;
            #5;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            add_bus = 16'h0064;
            tb_drive_data = 8'hAA;
            rw = 0;
            @(posedge clock);
            #5;

            add_bus = 16'h00C8;
            tb_drive_data = 8'hBB;
            @(posedge clock);
            #2;

            rw = 1;
            add_bus = 16'h0064;
            #5;
            #1;

            check_outputs(8'hAA);
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
        $dumpvars(0,add_bus, clock, rw);
    end

endmodule
