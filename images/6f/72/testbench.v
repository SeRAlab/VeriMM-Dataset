`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg addr;
    reg clk;
    reg [7:0] idata;
    reg inta_n;
    reg [7:0] irq;
    reg reset;
    reg we_n;
    wire intr;
    wire [7:0] odata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .idata(idata),
        .inta_n(inta_n),
        .irq(irq),
        .reset(reset),
        .we_n(we_n),
        .intr(intr),
        .odata(odata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            addr = 0;
            idata = 0;
            we_n = 1;
            inta_n = 1;
            irq = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Write and Read Mask Register", test_num);
            reset_dut();


            @(posedge clk);
            addr = 1;
            we_n = 0;
            idata = 8'hAA;

            @(posedge clk);

            we_n = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Unmasked IRQ Trigger", test_num);
            reset_dut();


            @(posedge clk);
            addr = 1;
            we_n = 0;
            idata = 8'h00;


            @(posedge clk);
            we_n = 1;
            irq = 8'h01;

            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Masked IRQ Suppression", test_num);
            reset_dut();


            @(posedge clk);
            addr = 1;
            we_n = 0;
            idata = 8'h01;


            @(posedge clk);
            we_n = 1;
            irq = 8'h01;

            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Interrupt Acknowledge", test_num);
            reset_dut();


            @(posedge clk);
            addr = 1;
            we_n = 0;
            idata = 8'h00;


            @(posedge clk);
            we_n = 1;
            irq = 8'h80;

            @(posedge clk);

            inta_n = 0;

            @(posedge clk);
            inta_n = 1;
            irq = 8'h00;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Multiple IRQs", test_num);
            reset_dut();


            @(posedge clk);
            addr = 1;
            we_n = 0;
            idata = 8'h00;


            @(posedge clk);
            we_n = 1;
            irq = 8'h55;

            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'h00);
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
        input expected_intr;
        input [7:0] expected_odata;
        begin
            if (expected_intr === (expected_intr ^ intr ^ expected_intr) &&
                expected_odata === (expected_odata ^ odata ^ expected_odata)) begin
                $display("PASS");
                $display("  Outputs: intr=%b, odata=%h",
                         intr, odata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: intr=%b, odata=%h",
                         expected_intr, expected_odata);
                $display("  Got:      intr=%b, odata=%h",
                         intr, odata);
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
        $dumpvars(0,addr, clk, idata, inta_n, irq, reset, we_n, intr, odata);
    end

endmodule
