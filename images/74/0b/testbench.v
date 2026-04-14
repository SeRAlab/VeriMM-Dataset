`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [18:0] addr;
    reg cen;
    reg clk;
    reg we;
    reg [35:0] write_data;
    wire [18:0] ram_address;
    wire ram_cen_b;
    wire ram_clk;
    wire ram_we_b;
    wire [35:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .cen(cen),
        .clk(clk),
        .we(we),
        .write_data(write_data),
        .ram_address(ram_address),
        .ram_cen_b(ram_cen_b),
        .ram_clk(ram_clk),
        .ram_we_b(ram_we_b),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 19'h0;
            cen = 0;
            we = 0;
            write_data = 36'h0;
            ram_data_drive = 36'bz;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            addr = 19'h12345;
            write_data = 36'hA5A5A5A5A;
            cen = 1;
            we = 1;
            @(posedge clk);
            #2;
            $display("Testcase 001: Write Operation");
            #1;

            check_outputs(19'h12345, 0, 1, 0, read_data);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            addr = 19'h54321;
            cen = 1;
            we = 0;
            ram_data_drive = 36'h5A5A5A5A5;
            @(posedge clk);
            #2;
            $display("Testcase 002: Read Operation");
            #1;

            check_outputs(19'h54321, 0, 1, 1, 36'h5A5A5A5A5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            addr = 19'h7FFFF;
            cen = 0;
            we = 1;
            @(posedge clk);
            #2;
            $display("Testcase 003: Chip Disable Logic");
            #1;

            check_outputs(ram_address, 1, 1, ram_we_b, read_data);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            addr = 19'h0000F;
            cen = 1;
            we = 0;
            @(posedge clk);
            #2;
            $display("Testcase 004: Write Disable Logic");
            #1;

            check_outputs(19'h0000F, 0, 1, 1, read_data);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            addr = 19'h7FFFF;
            write_data = 36'hFFFFFFFFF;
            cen = 1;
            we = 1;
            @(posedge clk);
            #2;
            $display("Testcase 005: Full Bus Width Test");
            #1;

            check_outputs(19'h7FFFF, 0, 1, 0, read_data);
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
        input [18:0] expected_ram_address;
        input expected_ram_cen_b;
        input expected_ram_clk;
        input expected_ram_we_b;
        input [35:0] expected_read_data;
        begin
            if (expected_ram_address === (expected_ram_address ^ ram_address ^ expected_ram_address) &&
                expected_ram_cen_b === (expected_ram_cen_b ^ ram_cen_b ^ expected_ram_cen_b) &&
                expected_ram_clk === (expected_ram_clk ^ ram_clk ^ expected_ram_clk) &&
                expected_ram_we_b === (expected_ram_we_b ^ ram_we_b ^ expected_ram_we_b) &&
                expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: ram_address=%h, ram_cen_b=%b, ram_clk=%b, ram_we_b=%b, read_data=%h",
                         ram_address, ram_cen_b, ram_clk, ram_we_b, read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ram_address=%h, ram_cen_b=%b, ram_clk=%b, ram_we_b=%b, read_data=%h",
                         expected_ram_address, expected_ram_cen_b, expected_ram_clk, expected_ram_we_b, expected_read_data);
                $display("  Got:      ram_address=%h, ram_cen_b=%b, ram_clk=%b, ram_we_b=%b, read_data=%h",
                         ram_address, ram_cen_b, ram_clk, ram_we_b, read_data);
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
        $dumpvars(0,addr, cen, clk, we, write_data, ram_address, ram_cen_b, ram_clk, ram_we_b, read_data);
    end

endmodule
