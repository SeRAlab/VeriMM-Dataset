`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg ps2c;
    reg ps2d;
    wire [15:0] xkey;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clr(clr),
        .ps2c(ps2c),
        .ps2d(ps2d),
        .xkey(xkey)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clr = 1;
            ps2c = 1;
            ps2d = 1;
            #20;
            clr = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Sending single key code (0x1C - 'A')", test_num);
            reset_dut();
            send_ps2_byte(8'h1C);
            #100;
            #1;

            check_outputs(16'h001C);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Sending sequence 0x1C then 0x1B", test_num);
            reset_dut();
            send_ps2_byte(8'h1C);
            send_ps2_byte(8'h1B);
            #100;
            #1;

            check_outputs(16'h1C1B);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Sending Break code for 0x23 (F0 23)", test_num);
            reset_dut();
            send_ps2_byte(8'hF0);
            send_ps2_byte(8'h23);
            #100;
            #1;

            check_outputs(16'hF023);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Verify reset behavior after data capture", test_num);
            reset_dut();
            send_ps2_byte(8'hAA);
            #100;

            if (xkey === 16'h00AA) begin
                reset_dut();
                #100;
                #1;

                check_outputs(16'h0000);
            end else begin
                $display("Failed initial capture for Reset test");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Sending 0x15, 0x16, then 0x1D", test_num);
            reset_dut();
            send_ps2_byte(8'h15);
            send_ps2_byte(8'h16);
            send_ps2_byte(8'h1D);
            #100;




            #1;





            check_outputs(16'h161D);
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
        input [15:0] expected_xkey;
        begin
            if (expected_xkey === (expected_xkey ^ xkey ^ expected_xkey)) begin
                $display("PASS");
                $display("  Outputs: xkey=%h",
                         xkey);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: xkey=%h",
                         expected_xkey);
                $display("  Got:      xkey=%h",
                         xkey);
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
        $dumpvars(0,clk, clr, ps2c, ps2d, xkey);
    end

endmodule
