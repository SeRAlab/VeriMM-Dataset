`timescale 1ns/1ps

module shift_register_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg load;
    reg rst;
    reg shift_left;
    reg shift_right;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_8bit dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .rst(rst),
        .shift_left(shift_left),
        .shift_right(shift_right),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            rst = 1;
            load = 0;
            shift_left = 0;
            shift_right = 0;
            data_in = 8'h00;
            @(posedge clk);
            rst = 0;

            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Synchronous Reset Verification");
            reset_dut();

            @(negedge clk);
            load = 1;
            data_in = 8'hFF;
            @(negedge clk);
            load = 0;

            @(negedge clk);
            rst = 1;
            @(negedge clk);
            rst = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Parallel Load Capability");
            reset_dut();
            @(negedge clk);
            load = 1;
            data_in = 8'hA5;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Single Shift Left");
            reset_dut();
            @(negedge clk);
            load = 1;
            data_in = 8'h01;
            @(negedge clk);
            load = 0;
            shift_left = 1;
            @(negedge clk);
            shift_left = 0;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Single Shift Right");
            reset_dut();
            @(negedge clk);
            load = 1;
            data_in = 8'h80;
            @(negedge clk);
            load = 0;
            shift_right = 1;
            @(negedge clk);
            shift_right = 0;
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Multiple Shift Left");
            reset_dut();
            @(negedge clk);
            load = 1;
            data_in = 8'hC1;
            @(negedge clk);
            load = 0;
            shift_left = 1;
            @(negedge clk);
            @(negedge clk);
            shift_left = 0;
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Multiple Shift Right");
            reset_dut();
            @(negedge clk);
            load = 1;
            data_in = 8'h83;
            @(negedge clk);
            load = 0;
            shift_right = 1;
            @(negedge clk);
            @(negedge clk);
            shift_right = 0;
            #1;

            check_outputs(8'h20);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning Testcase 007: Control Priority (Load vs Shift)");
            reset_dut();
            @(negedge clk);
            load = 1;
            data_in = 8'h55;
            shift_left = 1;
            @(negedge clk);
            load = 0;
            shift_left = 0;


            #1;



            check_outputs(8'h55);
        end
        endtask

    task testcase008;

        begin
            $display("\nRunning Testcase 008: Shift Out All Bits");
            reset_dut();
            @(negedge clk);
            load = 1;
            data_in = 8'hFF;
            @(negedge clk);
            load = 0;
            shift_left = 1;
            repeat(8) @(negedge clk);
            shift_left = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_8bit Testbench");
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
        $dumpvars(0,clk, data_in, load, rst, shift_left, shift_right, data_out);
    end

endmodule
