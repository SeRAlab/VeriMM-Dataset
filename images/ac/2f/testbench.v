`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg sram_clock;
    reg sram_read;
    reg [10:0] sram_read_address;
    reg sram_write;
    reg [10:0] sram_write_address;
    reg [31:0] sram_write_data;
    wire [31:0] sram_read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .sram_clock(sram_clock),
        .sram_read(sram_read),
        .sram_read_address(sram_read_address),
        .sram_write(sram_write),
        .sram_write_address(sram_write_address),
        .sram_write_data(sram_write_data),
        .sram_read_data(sram_read_data)
    );

    // Clock generation (10ns period)
    initial begin
        sram_clock = 0;
        forever #5 sram_clock = ~sram_clock;
    end

        task reset_dut;

        begin
            sram_read = 0;
            sram_read_address = 0;
            sram_write = 0;
            sram_write_address = 0;
            sram_write_data = 0;
            @(posedge sram_clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;


            sram_write = 1;
            sram_write_address = 11'd0;
            sram_write_data = 32'hAAAA_BBBB;
            @(posedge sram_clock);
            #1;
            sram_write = 0;


            sram_read = 1;
            sram_read_address = 11'd0;
            @(posedge sram_clock);
            #1;

            $display("Testcase 001: Basic Write/Read Address 0");
            #1;

            check_outputs(32'hAAAA_BBBB);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;


            sram_write = 1;
            sram_write_address = 11'd2047;
            sram_write_data = 32'h1234_5678;
            @(posedge sram_clock);
            #1;
            sram_write = 0;


            sram_read = 1;
            sram_read_address = 11'd2047;
            @(posedge sram_clock);
            #1;

            $display("Testcase 002: Boundary Address 2047");
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;


            sram_write = 1;
            sram_write_address = 11'd50;
            sram_write_data = 32'hCAFE_BABE;
            @(posedge sram_clock);
            #1;


            sram_write = 1;
            sram_write_address = 11'd100;
            sram_write_data = 32'h5555_AAAA;
            sram_read = 1;
            sram_read_address = 11'd50;
            @(posedge sram_clock);
            #1;

            $display("Testcase 003: Concurrent Write(100) and Read(50)");
            #1;

            check_outputs(32'hCAFE_BABE);


            sram_write = 0;
            sram_read = 1;
            sram_read_address = 11'd100;
            @(posedge sram_clock);
            #1;
            $display("Testcase 003: Verifying Address 100");
            #1;

            check_outputs(32'h5555_AAAA);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;


            sram_write = 1;
            sram_write_address = 11'd25;
            sram_write_data = 32'h0000_1111;
            @(posedge sram_clock);
            #1;


            sram_write = 0;
            sram_write_address = 11'd25;
            sram_write_data = 32'hFFFF_FFFF;
            @(posedge sram_clock);
            #1;


            sram_read = 1;
            sram_read_address = 11'd25;
            @(posedge sram_clock);
            #1;

            $display("Testcase 004: Write Enable Logic Verification");
            #1;

            check_outputs(32'h0000_1111);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;


            sram_write = 1;
            sram_write_address = 11'd500;
            sram_write_data = 32'h1111_1111;
            @(posedge sram_clock);
            #1;


            sram_write = 1;
            sram_write_address = 11'd500;
            sram_write_data = 32'h2222_2222;
            @(posedge sram_clock);
            #1;


            sram_write = 0;
            sram_read = 1;
            sram_read_address = 11'd500;
            @(posedge sram_clock);
            #1;

            $display("Testcase 005: Overwrite Address 500");
            #1;

            check_outputs(32'h2222_2222);
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
        input [31:0] expected_sram_read_data;
        begin
            if (expected_sram_read_data === (expected_sram_read_data ^ sram_read_data ^ expected_sram_read_data)) begin
                $display("PASS");
                $display("  Outputs: sram_read_data=%h",
                         sram_read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sram_read_data=%h",
                         expected_sram_read_data);
                $display("  Got:      sram_read_data=%h",
                         sram_read_data);
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
        $dumpvars(0,sram_clock, sram_read, sram_read_address, sram_write, sram_write_address, sram_write_data, sram_read_data);
    end

endmodule
