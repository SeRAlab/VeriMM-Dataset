`timescale 1ns/1ps

module PISO_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [7:0] parallel_in;
    reg shift;
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
            load = 0;
            shift = 0;
            parallel_in = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Load 8'hA5, Check Bit 7 (MSB)");
            test_num = 1;
            reset_dut();
            parallel_in = 8'b1010_0101;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Load 8'h5A, Check Bit 7 (MSB)");
            test_num = 2;
            reset_dut();
            parallel_in = 8'b0101_1010;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Load 8'hC0, Shift 1, Check Bit 6");
            test_num = 3;
            reset_dut();
            parallel_in = 8'b1100_0000;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift = 1;
            @(posedge clk);
            #1;
            shift = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Load 8'h01, Shift 7, Check Bit 0");
            test_num = 4;
            reset_dut();
            parallel_in = 8'b0000_0001;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift = 1;
            repeat(7) @(posedge clk);
            #1;
            shift = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Load 8'hFE, Shift 7, Check Bit 0");
            test_num = 5;
            reset_dut();
            parallel_in = 8'b1111_1110;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift = 1;
            repeat(7) @(posedge clk);
            #1;
            shift = 0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Verify data hold when load/shift are 0");
            test_num = 6;
            reset_dut();
            parallel_in = 8'hFF;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift = 0;
            parallel_in = 8'h00;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Verify Load priority over Shift");
            test_num = 7;
            reset_dut();
            parallel_in = 8'hAA;
            load = 1;
            shift = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Running Testcase 008: Shift 8 times and check for zero fill");
            test_num = 8;
            reset_dut();
            parallel_in = 8'hFF;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift = 1;
            repeat(8) @(posedge clk);
            #1;
            shift = 0;

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
        $dumpvars(0,clk, load, parallel_in, shift, serial_out);
    end

endmodule
