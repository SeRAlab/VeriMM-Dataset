`timescale 1ns/1ps

module sram_16bit_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] address;
    reg [15:0] data_in;
    reg read_enable;
    reg write_enable;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_16bit dut (
        .address(address),
        .data_in(data_in),
        .read_enable(read_enable),
        .write_enable(write_enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        read_enable = 0;
        forever #5 read_enable = ~read_enable;
    end

        task reset_dut;

    begin
        address = 0;
        data_in = 0;
        write_enable = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Testcase 001: Basic Write/Read at Address 0");


        address = 4'h0;
        data_in = 16'hABCD;
        write_enable = 1;
        #10;
        write_enable = 0;


        address = 4'h0;
        wait(read_enable == 1);
        #2;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Testcase 002: Write/Read at Boundary Address 15");


        address = 4'hF;
        data_in = 16'hFFFF;
        write_enable = 1;
        #10;
        write_enable = 0;


        address = 4'hF;
        wait(read_enable == 1);
        #2;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Testcase 003: Verify writing to one address doesn't corrupt another");


        address = 4'h5;
        data_in = 16'h1234;
        write_enable = 1;
        #10;


        address = 4'h6;
        data_in = 16'h5678;
        write_enable = 1;
        #10;
        write_enable = 0;


        address = 4'h5;
        wait(read_enable == 1);
        #2;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Testcase 004: Verify data is NOT written when write_enable is low");


        address = 4'hA;
        data_in = 16'hAAAA;
        write_enable = 1;
        #10;


        data_in = 16'h5555;
        write_enable = 0;
        #10;


        address = 4'hA;
        wait(read_enable == 1);
        #2;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Testcase 005: Verify data can be overwritten at the same address");


        address = 4'h2;
        data_in = 16'h0001;
        write_enable = 1;
        #10;


        data_in = 16'h8000;
        write_enable = 1;
        #10;
        write_enable = 0;


        address = 4'h2;
        wait(read_enable == 1);
        #2;
        #1;

        check_outputs(16'h8000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_16bit Testbench");
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
        input [15:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,address, data_in, read_enable, write_enable, data_out);
    end

endmodule
