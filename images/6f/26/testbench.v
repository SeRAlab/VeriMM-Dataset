`timescale 1ns/1ps

module shift_reg_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg load;
    reg rst_n;
    reg shift;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg_16bit dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .rst_n(rst_n),
        .shift(shift),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            rst_n = 0;
            load = 0;
            shift = 0;
            data_in = 16'h0;
            repeat (2) @(negedge clk);
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Reset Verification");
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Parallel Load");
            reset_dut();
            @(negedge clk);
            data_in = 16'hA5A5;
            load = 1;
            @(posedge clk);
            #2;
            load = 0;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Single Shift Left");
            reset_dut();

            @(negedge clk);
            data_in = 16'h0001;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            @(negedge clk);
            shift = 1;
            @(posedge clk);
            #2 shift = 0;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: 4-bit Shift Left");
            reset_dut();

            @(negedge clk);
            data_in = 16'h000F;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            repeat (4) begin
                @(negedge clk);
                shift = 1;
            end
            @(posedge clk);
            #2 shift = 0;
            #1;

            check_outputs(16'h00F0);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Load Priority Check");
            reset_dut();

            @(negedge clk);
            data_in = 16'h55AA;
            load = 1;
            shift = 1;
            @(posedge clk);
            #2;
            load = 0;
            shift = 0;

            #1;


            check_outputs(16'h55AA);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Data Retention");
            reset_dut();

            @(negedge clk);
            data_in = 16'h1234;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            repeat (5) @(posedge clk);
            #2;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase007;

        begin
            $display("\nTestcase 007: Shift Out All Bits");
            reset_dut();

            @(negedge clk);
            data_in = 16'h8000;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            @(negedge clk);
            shift = 1;
            repeat (16) @(posedge clk);
            #2 shift = 0;
            #1;

            check_outputs(16'h0000);
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
        $dumpvars(0,clk, data_in, load, rst_n, shift, data_out);
    end

endmodule
