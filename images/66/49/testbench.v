`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg direction;
    reg load;
    reg [7:0] parallel_in;
    reg rst_n;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .direction(direction),
        .load(load),
        .parallel_in(parallel_in),
        .rst_n(rst_n),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            load = 0;
            direction = 0;
            parallel_in = 0;
            #10;
            rst_n = 1;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Asynchronous Reset");
            reset_dut();

            load = 1;
            parallel_in = 8'hFF;
            @(negedge clk);
            load = 0;

            #2 rst_n = 0;
            #5;
            #1;

            check_outputs(8'h00);
            rst_n = 1;
            @(negedge clk);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Parallel Load");
            reset_dut();
            load = 1;
            parallel_in = 8'hA5;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Shift Left (4 positions)");
            reset_dut();

            load = 1;
            parallel_in = 8'h01;
            @(negedge clk);

            load = 0;
            direction = 0;
            repeat(4) @(negedge clk);

            #1;


            check_outputs(8'h10);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Shift Right (4 positions)");
            reset_dut();

            load = 1;
            parallel_in = 8'h80;
            @(negedge clk);

            load = 0;
            direction = 1;
            repeat(4) @(negedge clk);

            #1;


            check_outputs(8'h08);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Priority Check (Load over Shift)");
            reset_dut();

            load = 1;
            parallel_in = 8'h55;
            @(negedge clk);

            load = 1;
            direction = 0;
            parallel_in = 8'hAA;
            @(negedge clk);

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Shift Out All Bits");
            reset_dut();
            load = 1;
            parallel_in = 8'hFF;
            @(negedge clk);
            load = 0;
            direction = 0;
            repeat(8) @(negedge clk);

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Toggle Direction Mid-shift");
            reset_dut();
            load = 1;
            parallel_in = 8'h10;
            @(negedge clk);
            load = 0;
            direction = 0;
            repeat(2) @(negedge clk);
            direction = 1;
            repeat(1) @(negedge clk);
            #1;

            check_outputs(8'h20);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        $dumpvars(0,clk, direction, load, parallel_in, rst_n, data_out);
    end

endmodule
