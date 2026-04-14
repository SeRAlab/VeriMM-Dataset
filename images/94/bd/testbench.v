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
            write_n = 1;
            writedata = 0;
            in_port = 0;
            #20;
            reset_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Check default state after reset", test_num);


            address = 2'b00;
            chipselect = 1;
            #5;
            #1;

            check_outputs(1'b0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: Read from in_port (Address 0)", test_num);

            in_port = 1'b1;
            address = 2'b00;
            chipselect = 1;
            #10;

            #1;


            check_outputs(1'b0, 32'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %0d: Write to and read back IRQ Mask (Address 1)", test_num);


            address = 2'b01;
            chipselect = 1;
            write_n = 0;
            writedata = 32'h0000_0001;
            @(posedge clk);
            #2;
            write_n = 1;


            address = 2'b01;
            chipselect = 1;
            #10;
            #1;

            check_outputs(1'b0, 32'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: Verify IRQ assertion when in_port and mask are high", test_num);


            address = 2'b01;
            chipselect = 1;
            write_n = 0;
            writedata = 32'h0000_0001;
            @(posedge clk);
            #2;
            write_n = 1;


            in_port = 1'b1;
            #10;


            address = 2'b01;
            chipselect = 1;
            #5;
            #1;

            check_outputs(1'b1, 32'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %0d: Verify IRQ is 0 when mask is 0 even if in_port is 1", test_num);


            address = 2'b01;
            chipselect = 1;
            write_n = 0;
            writedata = 32'h0;
            @(posedge clk);
            #2;
            write_n = 1;

            in_port = 1'b1;
            #10;

            address = 2'b00;
            #5;
            #1;

            check_outputs(1'b0, 32'h1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Testcase %0d: Check module when chipselect is low", test_num);

            in_port = 1'b1;
            address = 2'b00;
            chipselect = 0;
            #10;





            if (irq === 1'b0) begin
                 $display("PASS - IRQ remains low (Mask is 0)");
            end
            #1;

            check_outputs(1'b0, 32'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Testcase %0d: Write multiple bits to mask register", test_num);

            address = 2'b01;
            chipselect = 1;
            write_n = 0;
            writedata = 32'hFFFF_FFFF;
            @(posedge clk);
            #2;
            write_n = 1;
            #5;

            in_port = 1'b1;
            #5;
            address = 2'b01;
            #1;

            check_outputs(1'b1, 32'hFFFF_FFFF);
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
        testcase007();
        
        
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
