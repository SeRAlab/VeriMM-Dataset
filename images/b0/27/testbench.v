`timescale 1ns/1ps

module shift_reg_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load_en;
    reg [15:0] parallel_in;
    reg rst_n;
    reg shift_dir;
    reg shift_en;
    wire [15:0] parallel_out;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg_16bit dut (
        .clk(clk),
        .load_en(load_en),
        .parallel_in(parallel_in),
        .rst_n(rst_n),
        .shift_dir(shift_dir),
        .shift_en(shift_en),
        .parallel_out(parallel_out),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            load_en = 0;
            shift_en = 0;
            shift_dir = 0;
            parallel_in = 16'h0000;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Reset Verification");
            reset_dut();

            #1;


            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Parallel Load 16'hAAAA");
            reset_dut();
            parallel_in = 16'hAAAA;
            load_en = 1;
            shift_dir = 0;
            @(posedge clk);
            #1;
            load_en = 0;

            #1;


            check_outputs(16'hAAAA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Left Shift (0x0001 -> 0x0002)");
            reset_dut();

            parallel_in = 16'h0001;
            load_en = 1;
            @(posedge clk);
            #1;

            load_en = 0;
            shift_en = 1;
            shift_dir = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0002, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Right Shift (0x8000 -> 0x4000)");
            reset_dut();

            parallel_in = 16'h8000;
            load_en = 1;
            @(posedge clk);
            #1;

            load_en = 0;
            shift_en = 1;
            shift_dir = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h4000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Serial Out MSB Check (Left Shift 0x8000)");
            reset_dut();
            parallel_in = 16'h8000;
            load_en = 1;
            @(posedge clk);
            #1;
            load_en = 0;
            shift_en = 1;
            shift_dir = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Serial Out LSB Check (Right Shift 0x0001)");
            reset_dut();
            parallel_in = 16'h0001;
            load_en = 1;
            @(posedge clk);
            #1;
            load_en = 0;
            shift_en = 1;
            shift_dir = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Multiple Left Shifts (4 bits)");
            reset_dut();
            parallel_in = 16'h000F;
            load_en = 1;
            @(posedge clk);
            #1;
            load_en = 0;
            shift_en = 1;
            shift_dir = 0;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(16'h00F0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase 008: Load Priority Check");
            reset_dut();

            parallel_in = 16'h1234;
            load_en = 1;
            @(posedge clk);
            #1;

            parallel_in = 16'h5678;
            load_en = 1;
            shift_en = 1;
            shift_dir = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h5678, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase 009: Shift Enable Inactive Check");
            reset_dut();
            parallel_in = 16'hDEAD;
            load_en = 1;
            @(posedge clk);
            #1;
            load_en = 0;
            shift_en = 0;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(16'hDEAD, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_reg_16bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [15:0] expected_parallel_out;
        input expected_serial_out;
        begin
            if (expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out) &&
                expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: parallel_out=%h, serial_out=%b",
                         parallel_out, serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parallel_out=%h, serial_out=%b",
                         expected_parallel_out, expected_serial_out);
                $display("  Got:      parallel_out=%h, serial_out=%b",
                         parallel_out, serial_out);
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
        $dumpvars(0,clk, load_en, parallel_in, rst_n, shift_dir, shift_en, parallel_out, serial_out);
    end

endmodule
