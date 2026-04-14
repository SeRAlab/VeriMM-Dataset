`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [7:0] data;
    reg reset;
    reg rs;
    reg write_start;
    wire [4:0] lcd_ctrl;
    wire [7:0] lcd_data;
    wire lcd_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .data(data),
        .reset(reset),
        .rs(rs),
        .write_start(write_start),
        .lcd_ctrl(lcd_ctrl),
        .lcd_data(lcd_data),
        .lcd_done(lcd_done)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            clock = 0;
            reset = 1;
            data = 8'h00;
            rs = 0;
            write_start = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write Command 0x01 (Clear Display)", test_num);
            reset_dut();

            @(posedge clock);
            data = 8'h01;
            rs = 0;
            write_start = 1;
            @(posedge clock);
            write_start = 0;


            fork : wait_done_001
                begin
                    wait(lcd_done == 1);
                    disable wait_done_001;
                end
                begin
                    #2000;
                    $display("Timeout waiting for lcd_done");
                    disable wait_done_001;
                end
            join




            #1;





            check_outputs(lcd_ctrl, 8'h01, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write Data 0x41 ('A')", test_num);
            reset_dut();

            @(posedge clock);
            data = 8'h41;
            rs = 1;
            write_start = 1;
            @(posedge clock);
            write_start = 0;

            fork : wait_done_002
                begin
                    wait(lcd_done == 1);
                    disable wait_done_002;
                end
                begin
                    #2000;
                    $display("Timeout waiting for lcd_done");
                    disable wait_done_002;
                end
            join

            #1;


            check_outputs(lcd_ctrl, 8'h41, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write Command 0x38 (8-bit, 2-line)", test_num);
            reset_dut();

            @(posedge clock);
            data = 8'h38;
            rs = 0;
            write_start = 1;
            @(posedge clock);
            write_start = 0;

            fork : wait_done_003
                begin
                    wait(lcd_done == 1);
                    disable wait_done_003;
                end
                begin
                    #2000;
                    $display("Timeout waiting for lcd_done");
                    disable wait_done_003;
                end
            join

            #1;


            check_outputs(lcd_ctrl, 8'h38, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write Data 0x5A ('Z')", test_num);
            reset_dut();

            @(posedge clock);
            data = 8'h5A;
            rs = 1;
            write_start = 1;
            @(posedge clock);
            write_start = 0;

            fork : wait_done_004
                begin
                    wait(lcd_done == 1);
                    disable wait_done_004;
                end
                begin
                    #2000;
                    $display("Timeout waiting for lcd_done");
                    disable wait_done_004;
                end
            join

            #1;


            check_outputs(lcd_ctrl, 8'h5A, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Idle State Verification", test_num);
            reset_dut();

            #100;


            #1;



            check_outputs(lcd_ctrl, 8'h00, 1'b0);
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
        input [4:0] expected_lcd_ctrl;
        input [7:0] expected_lcd_data;
        input expected_lcd_done;
        begin
            if (expected_lcd_ctrl === (expected_lcd_ctrl ^ lcd_ctrl ^ expected_lcd_ctrl) &&
                expected_lcd_data === (expected_lcd_data ^ lcd_data ^ expected_lcd_data) &&
                expected_lcd_done === (expected_lcd_done ^ lcd_done ^ expected_lcd_done)) begin
                $display("PASS");
                $display("  Outputs: lcd_ctrl=%h, lcd_data=%h, lcd_done=%b",
                         lcd_ctrl, lcd_data, lcd_done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lcd_ctrl=%h, lcd_data=%h, lcd_done=%b",
                         expected_lcd_ctrl, expected_lcd_data, expected_lcd_done);
                $display("  Got:      lcd_ctrl=%h, lcd_data=%h, lcd_done=%b",
                         lcd_ctrl, lcd_data, lcd_done);
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
        $dumpvars(0,clock, data, reset, rs, write_start, lcd_ctrl, lcd_data, lcd_done);
    end

endmodule
