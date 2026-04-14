`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg baudclk;
    reg rxd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .baudclk(baudclk),
        .rxd(rxd)
    );

        task reset_dut;

        begin
            rxd = 1;
            repeat (5) @(posedge baudclk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            exp_byte = 8'h41;
            exp_err = 0;
            send_uart_frame(8'h41, 1'b1);
            #1;

            check_outputs();
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            exp_byte = 8'hFF;
            exp_err = 0;
            send_uart_frame(8'hFF, 1'b1);
            #1;

            check_outputs();
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            exp_byte = 8'h00;
            exp_err = 0;
            send_uart_frame(8'h00, 1'b1);
            #1;

            check_outputs();
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            exp_byte = 8'h55;
            exp_err = 1;
            send_uart_frame(8'h55, 1'b0);
            #1;

            check_outputs();
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            exp_byte = 8'hAA;
            exp_err = 0;
            send_uart_frame(8'hAA, 1'b1);
            #1;

            check_outputs();


            exp_byte = 8'h12;
            exp_err = 0;
            send_uart_frame(8'h12, 1'b1);
            #1;

            check_outputs();
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
        $dumpvars(0,baudclk, rxd);
    end

endmodule
