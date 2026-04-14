`timescale 1ns/1ps

module PISO_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [4:0] parallel_in;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PISO dut (
        .clk(clk),
        .load(load),
        .parallel_in(parallel_in),
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
            parallel_in = 5'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            parallel_in = 5'b10110;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;

            $display("Testcase 001: Loading 5'b10110, checking bit 4");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            parallel_in = 5'b10110;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            @(posedge clk);
            #1;

            $display("Testcase 002: Shifting 5'b10110 once, checking bit 3");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            parallel_in = 5'b10110;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            repeat(2) @(posedge clk);
            #1;

            $display("Testcase 003: Shifting 5'b10110 twice, checking bit 2");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            parallel_in = 5'b10110;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            repeat(3) @(posedge clk);
            #1;

            $display("Testcase 004: Shifting 5'b10110 three times, checking bit 1");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            parallel_in = 5'b10110;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            repeat(4) @(posedge clk);
            #1;

            $display("Testcase 005: Shifting 5'b10110 four times, checking bit 0");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            parallel_in = 5'b00000;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            $display("Testcase 006: Loading all zeros, checking MSB");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            parallel_in = 5'b11111;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            $display("Testcase 007: Loading all ones, checking MSB");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            parallel_in = 5'b11111;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            repeat(5) @(posedge clk);
            #1;
            $display("Testcase 008: Shifting beyond 5 cycles, checking if 0 shifts in");
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
        $display("PISO Testbench");
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
        $dumpvars(0,clk, load, parallel_in, serial_out);
    end

endmodule
