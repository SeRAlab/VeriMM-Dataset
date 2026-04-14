`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] address;
    reg chipselect;
    reg clk;
    reg in_port;
    reg reset_n;
    reg write_n;
    reg [31:0] writedata;
    wire irq;
    wire [31:0] readdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .chipselect(chipselect),
        .clk(clk),
        .in_port(in_port),
        .reset_n(reset_n),
        .write_n(write_n),
        .writedata(writedata),
        .irq(irq),
        .readdata(readdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            address = 0;
            chipselect = 0;
            in_port = 0;
            write_n = 1;
            writedata = 0;
            repeat(2) @(posedge clk);
            reset_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            chipselect = 1;
            address = 2'b00;
            write_n = 1;
            #1;

            check_outputs(1'b0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            chipselect = 1;
            write_n = 0;
            address = 2'b00;
            writedata = 32'hDEADBEEF;
            @(posedge clk);

            write_n = 1;
            #1;

            check_outputs(1'b0, 32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            chipselect = 1;
            write_n = 0;
            address = 2'b01;
            writedata = 32'hCAFEBABE;
            @(posedge clk);

            write_n = 1;
            #1;

            check_outputs(1'b0, 32'hCAFEBABE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            chipselect = 1;
            write_n = 0;
            address = 2'b11;
            writedata = 32'h00000001;
            @(posedge clk);

            write_n = 1;
            in_port = 1;
            #1;

            check_outputs(1'b1, 32'h00000001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            chipselect = 1;
            write_n = 0;
            address = 2'b11;
            writedata = 32'h00000000;
            @(posedge clk);

            write_n = 1;
            in_port = 1;
            #1;

            check_outputs(1'b0, 32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            chipselect = 0;
            write_n = 0;
            address = 2'b00;
            writedata = 32'hFFFFFFFF;
            @(posedge clk);

            chipselect = 1;
            write_n = 1;
            #1;

            check_outputs(1'b0, 32'h00000000);
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
        input expected_irq;
        input [31:0] expected_readdata;
        begin
            if (expected_irq === (expected_irq ^ irq ^ expected_irq) &&
                expected_readdata === (expected_readdata ^ readdata ^ expected_readdata)) begin
                $display("PASS");
                $display("  Outputs: irq=%b, readdata=%h",
                         irq, readdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: irq=%b, readdata=%h",
                         expected_irq, expected_readdata);
                $display("  Got:      irq=%b, readdata=%h",
                         irq, readdata);
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
        $dumpvars(0,address, chipselect, clk, in_port, reset_n, write_n, writedata, irq, readdata);
    end

endmodule
