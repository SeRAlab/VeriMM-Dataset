`timescale 1ns/1ps

module ShiftRegister_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg en;
    reg load;
    reg rst;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ShiftRegister dut (
        .clk(clk),
        .data_in(data_in),
        .en(en),
        .load(load),
        .rst(rst),
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
            rst = 1;
            @(negedge clk);
            rst = 0;
        end
        endtask
    task init_signals;

        begin
            data_in = 8'b0;
            en = 0;
            load = 0;
            rst = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            init_signals();

            data_in = 8'hFF;
            load = 1;
            @(negedge clk);
            load = 0;

            reset_dut();

            $display("Testcase 001: Synchronous Reset");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data_in = 8'b10101011;
            load = 1;
            @(negedge clk);
            load = 0;

            $display("Testcase 002: Parallel Load (Checking LSB)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data_in = 8'b00000010;
            load = 1;
            @(negedge clk);
            load = 0;
            en = 1;
            @(negedge clk);
            en = 0;
            $display("Testcase 003: Shift Right 1 position");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data_in = 8'b10000000;
            load = 1;
            @(negedge clk);
            load = 0;
            en = 1;
            repeat(7) @(negedge clk);
            en = 0;
            $display("Testcase 004: Shift Right 7 positions (Checking MSB)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            data_in = 8'b00000010;
            load = 1;
            @(negedge clk);
            load = 0;
            en = 0;
            repeat(3) @(negedge clk);
            $display("Testcase 005: Enable inactive (Should not shift)");
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
        $display("ShiftRegister Testbench");
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
        input expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b",
                         expected_data_out);
                $display("  Got:      data_out=%b",
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
        $dumpvars(0,clk, data_in, en, load, rst, data_out);
    end

endmodule
