`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [18:0] a;
    reg ce_n;
    reg oe_n;
    reg we_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .ce_n(ce_n),
        .oe_n(oe_n),
        .we_n(we_n)
    );

    // Clock generation (10ns period)
    initial begin
        ce_n = 0;
        forever #5 ce_n = ~ce_n;
    end

        task reset_dut;

        begin
            a = 0;
            ce_n = 1;
            oe_n = 1;
            we_n = 1;
            d_reg = 0;
            d_drive_en = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            write_mem(19'h010, 8'hA5);


            a = 19'h010;
            ce_n = 0;
            oe_n = 0;
            we_n = 1;
            #10;
            #1;

            check_outputs(8'hA5, 1);
            ce_n = 1;
            oe_n = 1;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            write_mem(19'h020, 8'h55);


            a = 19'h020;
            ce_n = 1;
            oe_n = 0;
            we_n = 1;
            #10;
            #1;

            check_outputs(8'hzz, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            write_mem(19'h030, 8'hFF);


            a = 19'h030;
            ce_n = 0;
            oe_n = 1;
            we_n = 1;
            #10;
            #1;

            check_outputs(8'hzz, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            write_mem(19'h1FF, 8'h12);
            write_mem(19'h001, 8'h34);


            a = 19'h1FF;
            ce_n = 0; oe_n = 0; we_n = 1;
            #10;
            if (d !== 8'h12) begin
                #1;

                check_outputs(8'h12, 1);
            end else begin

                a = 19'h001;
                #10;
                #1;

                check_outputs(8'h34, 1);
            end
            ce_n = 1; oe_n = 1;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            a = 19'h050;
            d_reg = 8'hBE;
            d_drive_en = 1;
            ce_n = 0;
            oe_n = 0;
            we_n = 0;
            #10;
            we_n = 1;
            d_drive_en = 0;
            #10;
            #1;

            check_outputs(8'hBE, 1);
            ce_n = 1; oe_n = 1;
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
        $dumpvars(0,a, ce_n, oe_n, we_n);
    end

endmodule
