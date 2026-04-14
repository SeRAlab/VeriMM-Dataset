`timescale 1ns/1ps

module piso_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg load;
    reg reset;
    reg shift;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    piso_shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .reset(reset),
        .shift(shift),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            shift = 0;
            data_in = 8'b0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Load 8'b10101010, check MSB...");
            reset_dut();
            data_in = 8'b10101010;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Load 8'b11001100, shift 1, check bit 6...");
            reset_dut();
            data_in = 8'b11001100;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            shift = 1;
            @(posedge clk);
            #1 shift = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Load 8'b00000001, shift 7, check LSB...");
            reset_dut();
            data_in = 8'b00000001;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            shift = 1;
            repeat(7) @(posedge clk);
            #1 shift = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Load 8'hFF, shift 3, then Reset...");
            reset_dut();
            data_in = 8'hFF;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            shift = 1;
            repeat(3) @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1 reset = 0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Load 8'b00000000, check MSB...");
            reset_dut();
            data_in = 8'b00000000;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Load 8'b11110000, shift 4, check bit 3...");
            reset_dut();
            data_in = 8'b11110000;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            shift = 1;
            repeat(4) @(posedge clk);
            #1 shift = 0;

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
        $display("piso_shift_register Testbench");
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
        $dumpvars(0,clk, data_in, load, reset, shift, serial_out);
    end

endmodule
