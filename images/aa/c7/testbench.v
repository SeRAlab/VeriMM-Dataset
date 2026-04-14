`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] bus_addr;
    reg [3:0] bus_byte_enable;
    reg bus_read;
    reg bus_write;
    reg [31:0] bus_write_data;
    reg clk;
    reg rst;
    wire bus_ack;
    wire [31:0] bus_read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bus_addr(bus_addr),
        .bus_byte_enable(bus_byte_enable),
        .bus_read(bus_read),
        .bus_write(bus_write),
        .bus_write_data(bus_write_data),
        .clk(clk),
        .rst(rst),
        .bus_ack(bus_ack),
        .bus_read_data(bus_read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            bus_addr = 0;
            bus_byte_enable = 0;
            bus_read = 0;
            bus_write = 0;
            bus_write_data = 0;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset State check");
            reset_dut();

            #1;


            check_outputs(1'b0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Read from FIFO Status Address");
            reset_dut();
            @(posedge clk);
            bus_addr = ADDR_FIFO_STATUS;
            bus_read = 1'b1;
            bus_byte_enable = 4'hF;
            @(posedge clk);
            #1;


            if (bus_ack === 1'b1) begin
                pass_count = pass_count + 1;
                $display("PASS: Bus Ack asserted for FIFO Read. Data: %h", bus_read_data);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Bus Ack not asserted for FIFO Read");
            end
            bus_read = 1'b0;
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: First Read from Right Audio Data");
            reset_dut();
            @(posedge clk);
            bus_addr = ADDR_RIGHT_DATA;
            bus_read = 1'b1;
            bus_byte_enable = 4'hF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, bus_read_data);
            bus_read = 1'b0;
        end
        endtask

    task testcase004;

        reg [31:0] first_val;
        begin
            $display("Testcase 004: Verify Counter Increment for Right Audio");
            reset_dut();


            @(posedge clk);
            bus_addr = ADDR_RIGHT_DATA;
            bus_read = 1'b1;
            @(posedge clk);
            #1 first_val = bus_read_data;
            bus_read = 1'b0;


            @(posedge clk);
            bus_read = 1'b1;
            @(posedge clk);
            #1;


            if (bus_ack === 1'b1 && bus_read_data == (first_val + 1)) begin
                $display("PASS: Counter incremented from %h to %h", first_val, bus_read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Counter did not increment correctly. Got %h, Expected %h", bus_read_data, first_val + 1);
                fail_count = fail_count + 1;
            end
            bus_read = 1'b0;
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Write operation to Bus");
            reset_dut();
            @(posedge clk);
            bus_addr = ADDR_OTHER;
            bus_write = 1'b1;
            bus_write_data = 32'hAAAA_5555;
            bus_byte_enable = 4'hF;
            @(posedge clk);
            #1;

            if (bus_ack === 1'b1) begin
                $display("PASS: Bus Ack asserted for Write");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Bus Ack not asserted for Write");
                fail_count = fail_count + 1;
            end
            bus_write = 1'b0;
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Verification of signal deassertion after transaction");
            reset_dut();

            @(posedge clk);
            bus_addr = ADDR_FIFO_STATUS;
            bus_read = 1'b1;
            @(posedge clk);

            bus_read = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, bus_read_data);
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
        input expected_bus_ack;
        input [31:0] expected_bus_read_data;
        begin
            if (expected_bus_ack === (expected_bus_ack ^ bus_ack ^ expected_bus_ack) &&
                expected_bus_read_data === (expected_bus_read_data ^ bus_read_data ^ expected_bus_read_data)) begin
                $display("PASS");
                $display("  Outputs: bus_ack=%b, bus_read_data=%h",
                         bus_ack, bus_read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bus_ack=%b, bus_read_data=%h",
                         expected_bus_ack, expected_bus_read_data);
                $display("  Got:      bus_ack=%b, bus_read_data=%h",
                         bus_ack, bus_read_data);
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
        $dumpvars(0,bus_addr, bus_byte_enable, bus_read, bus_write, bus_write_data, clk, rst, bus_ack, bus_read_data);
    end

endmodule
