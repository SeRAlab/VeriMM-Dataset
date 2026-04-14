`timescale 1ns/1ps

module PISO_Shift_Register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data_in;
    reg load;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PISO_Shift_Register dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        load = 0;
        data_in = 5'b0;
        @(posedge clk);
        #1;

        load = 1;
        data_in = 5'b00000;
        @(posedge clk);
        #1;
        load = 0;
    end
    endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        data_in = 5'b10101;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        $display("Testcase 001: Checking bit 4 (MSB) of 10101");
        #1;

        check_outputs(1'b1);
    end
    endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        data_in = 5'b10101;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        @(posedge clk);
        #1;
        $display("Testcase 002: Checking bit 3 of 10101");
        #1;

        check_outputs(1'b0);
    end
    endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        data_in = 5'b10101;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        @(posedge clk);
        @(posedge clk);
        #1;
        $display("Testcase 003: Checking bit 2 of 10101");
        #1;

        check_outputs(1'b1);
    end
    endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        data_in = 5'b10101;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #1;
        $display("Testcase 004: Checking bit 1 of 10101");
        #1;

        check_outputs(1'b0);
    end
    endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        data_in = 5'b10101;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #1;
        $display("Testcase 005: Checking bit 0 (LSB) of 10101");
        #1;

        check_outputs(1'b1);
    end
    endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        data_in = 5'b11111;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        repeat(4) @(posedge clk);
        #1;
        $display("Testcase 006: Checking bit 0 of 11111");
        #1;

        check_outputs(1'b1);
    end
    endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        data_in = 5'b00000;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        repeat(4) @(posedge clk);
        #1;
        $display("Testcase 007: Checking bit 0 of 00000");
        #1;

        check_outputs(1'b0);
    end
    endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();

        data_in = 5'b11111;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        @(posedge clk);

        data_in = 5'b01010;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        $display("Testcase 008: Checking if load overrides shift (New MSB 0)");
        #1;

        check_outputs(1'b0);
    end
    endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PISO_Shift_Register Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_serial_out;
        begin
            if (expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: serial_out=%b",
                         serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: serial_out=%b",
                         expected_serial_out);
                $display("  Got:      serial_out=%b",
                         serial_out);
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
        $dumpvars(0,clk, data_in, load, serial_out);
    end

endmodule
