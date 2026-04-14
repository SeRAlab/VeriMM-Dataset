`timescale 1ns/1ps

module shift_register_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [15:0] parallel_data;
    reg rst;
    reg shift_left;
    wire [15:0] reg_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_16bit dut (
        .clk(clk),
        .load(load),
        .parallel_data(parallel_data),
        .rst(rst),
        .shift_left(shift_left),
        .reg_out(reg_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            load = 0;
            shift_left = 0;
            parallel_data = 16'h0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Reset Check");
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Parallel Load");
            reset_dut();
            load = 1;
            parallel_data = 16'hA5A5;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Shift Left Single Bit");
            reset_dut();

            load = 1;
            parallel_data = 16'h0001;
            @(posedge clk);
            #1 load = 0;
            shift_left = 1;
            @(posedge clk);
            #1 shift_left = 0;

            #1;


            check_outputs(16'h0002);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Shift Right Single Bit");
            reset_dut();

            load = 1;
            parallel_data = 16'h8000;
            @(posedge clk);
            #1 load = 0;
            shift_left = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h4000);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Multiple Shift Lefts (4 bits)");
            reset_dut();
            load = 1;
            parallel_data = 16'h000F;
            @(posedge clk);
            #1 load = 0;
            shift_left = 1;
            repeat(4) @(posedge clk);
            #1 shift_left = 0;

            #1;


            check_outputs(16'h00F0);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Multiple Shift Rights (8 bits)");
            reset_dut();
            load = 1;
            parallel_data = 16'hFF00;
            @(posedge clk);
            #1 load = 0;
            shift_left = 0;
            repeat(8) @(posedge clk);
            #1;

            #1;


            check_outputs(16'h00FF);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Shift Left Out of Bounds");
            reset_dut();
            load = 1;
            parallel_data = 16'h8000;
            @(posedge clk);
            #1 load = 0;
            shift_left = 1;
            @(posedge clk);
            #1 shift_left = 0;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            $display("Running Testcase 008: Shift Right Out of Bounds");
            reset_dut();
            load = 1;
            parallel_data = 16'h0001;
            @(posedge clk);
            #1 load = 0;
            shift_left = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase009;

        begin
            $display("Running Testcase 009: Load Priority Over Shift");
            reset_dut();

            load = 1;
            parallel_data = 16'h1111;
            @(posedge clk);
            #1;

            load = 1;
            shift_left = 1;
            parallel_data = 16'hAAAA;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hAAAA);
        end
        endtask

    task testcase010;

        begin
            $display("Running Testcase 010: Complex Sequence (Load -> Left -> Right)");
            reset_dut();
            load = 1;
            parallel_data = 16'h1234;
            @(posedge clk);
            #1 load = 0;
            shift_left = 1;
            @(posedge clk);
            #1 shift_left = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_16bit Testbench");
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
        testcase010();
        
        
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
        input [15:0] expected_reg_out;
        begin
            if (expected_reg_out === (expected_reg_out ^ reg_out ^ expected_reg_out)) begin
                $display("PASS");
                $display("  Outputs: reg_out=%h",
                         reg_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_out=%h",
                         expected_reg_out);
                $display("  Got:      reg_out=%h",
                         reg_out);
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
        $dumpvars(0,clk, load, parallel_data, rst, shift_left, reg_out);
    end

endmodule
