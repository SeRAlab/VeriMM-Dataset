`timescale 1ns/1ps

module EEPROM_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] data_in;
    reg re;
    reg rst;
    reg we;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    EEPROM dut (
        .data_in(data_in),
        .re(re),
        .rst(rst),
        .we(we),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        re = 0;
        forever #5 re = ~re;
    end

        task reset_dut;

    begin
        rst = 1;
        we = 0;
        data_in = 8'h00;
        #12;
        rst = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        @(posedge re);
        #2;
        $display("Testcase 001: Initial Reset Check");
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();

        data_in = 8'hA5;
        we = 1;
        #10;
        we = 0;

        @(posedge re);
        #2;
        $display("Testcase 002: Write 0xA5 and Read Check");
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        data_in = 8'h5A;
        we = 1;
        #10;
        we = 0;
        @(posedge re);
        #2;
        $display("Testcase 003: Write 0x5A and Read Check");
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();

        data_in = 8'hAA;
        we = 1;
        #10;
        we = 0;

        data_in = 8'hFF;
        we = 0;
        #10;
        @(posedge re);
        #2;
        $display("Testcase 004: Write Disable (we=0) Check");
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();

        data_in = 8'hFF;
        we = 1;
        #10;
        we = 0;
        @(posedge re);
        #1;

        rst = 1;
        #2;
        $display("Testcase 005: Async Reset Mid-Operation Check");
        #1;

        check_outputs(8'h00);
        rst = 0;
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();

        data_in = 8'h11;
        we = 1; #10; we = 0;

        @(posedge re);
        #2;

        @(negedge re);
        #1;

        data_in = 8'h22;
        we = 1; #2; we = 0;

        $display("Testcase 006: Read Enable Hold Check (re=0)");
        #1;

        check_outputs(8'h11);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        data_in = 8'hCC;
        we = 1; #10; we = 0;
        @(posedge re); #2;
        @(negedge re); #1;
        data_in = 8'hDD;
        we = 1; #2; we = 0;

        @(posedge re);
        #2;
        $display("Testcase 007: Hold Recovery Check (re 0->1)");
        #1;

        check_outputs(8'hDD);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("EEPROM Testbench");
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
        input [7:0] expected_data_out;
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
        $dumpvars(0,data_in, re, rst, we, data_out);
    end

endmodule
