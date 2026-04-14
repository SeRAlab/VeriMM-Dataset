`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] cpu_address;
    reg cpu_read;
    reg [31:0] cpu_readdata;
    reg cpu_wait;
    reg cpu_write;
    reg [31:0] cpu_writedata;
    wire [35:0] atm;
    wire [35:0] dtm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .cpu_address(cpu_address),
        .cpu_read(cpu_read),
        .cpu_readdata(cpu_readdata),
        .cpu_wait(cpu_wait),
        .cpu_write(cpu_write),
        .cpu_writedata(cpu_writedata),
        .atm(atm),
        .dtm(dtm)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            cpu_address = 32'h0;
            cpu_read = 0;
            cpu_readdata = 32'h0;
            cpu_wait = 0;
            cpu_write = 0;
            cpu_writedata = 32'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Standard Write Operation");
            reset_dut();
            cpu_address = 32'hAAAA_BBBB;
            cpu_writedata = 32'h1234_5678;
            cpu_write = 1;
            cpu_wait = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs({TAG_WRITE_ATM, 32'hAAAA_BBBB}, {TAG_WRITE_DTM, 32'h1234_5678});
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Standard Read Operation");
            reset_dut();
            cpu_address = 32'hCCCC_DDDD;
            cpu_readdata = 32'h8765_4321;
            cpu_read = 1;
            cpu_wait = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs({TAG_READ_ATM, 32'hCCCC_DDDD}, {TAG_READ_DTM, 32'h8765_4321});
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write with Wait Signal active");
            reset_dut();
            cpu_address = 32'h1111_2222;
            cpu_writedata = 32'h9999_8888;
            cpu_write = 1;
            cpu_wait = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs({TAG_NEUTRAL, 32'h1111_2222}, {TAG_NEUTRAL, 32'h0000_0000});
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Read with Wait Signal active");
            reset_dut();
            cpu_address = 32'h3333_4444;
            cpu_readdata = 32'h5555_6666;
            cpu_read = 1;
            cpu_wait = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs({TAG_NEUTRAL, 32'h3333_4444}, {TAG_NEUTRAL, 32'h5555_6666});
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Idle State");
            reset_dut();
            cpu_address = 32'hF0F0_F0F0;
            cpu_readdata = 32'h0F0F_0F0F;
            cpu_write = 0;
            cpu_read = 0;
            cpu_wait = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs({TAG_NEUTRAL, 32'hF0F0_F0F0}, {TAG_NEUTRAL, 32'h0F0F_0F0F});
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Simultaneous Read and Write");
            reset_dut();
            cpu_address = 32'h7777_8888;
            cpu_writedata = 32'hAAAA_AAAA;
            cpu_readdata = 32'hBBBB_BBBB;
            cpu_write = 1;
            cpu_read = 1;
            cpu_wait = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs({TAG_WRITE_ATM, 32'h7777_8888}, {TAG_WRITE_DTM, 32'hAAAA_AAAA});
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
        input [35:0] expected_atm;
        input [35:0] expected_dtm;
        begin
            if (expected_atm === (expected_atm ^ atm ^ expected_atm) &&
                expected_dtm === (expected_dtm ^ dtm ^ expected_dtm)) begin
                $display("PASS");
                $display("  Outputs: atm=%h, dtm=%h",
                         atm, dtm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: atm=%h, dtm=%h",
                         expected_atm, expected_dtm);
                $display("  Got:      atm=%h, dtm=%h",
                         atm, dtm);
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
        $dumpvars(0,clk, cpu_address, cpu_read, cpu_readdata, cpu_wait, cpu_write, cpu_writedata, atm, dtm);
    end

endmodule
