`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [7:0] parallel_in;
    reg rst;
    reg serial_in;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .load(load),
        .parallel_in(parallel_in),
        .rst(rst),
        .serial_in(serial_in),
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
            load = 0;
            parallel_in = 8'h00;
            serial_in = 0;
            @(negedge clk);
            rst = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Reset Check");
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Parallel Load");
            reset_dut();
            @(negedge clk);
            parallel_in = 8'hA5;
            load = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Shift Left (serial_in=0)");
            reset_dut();

            @(negedge clk);
            parallel_in = 8'h55;
            load = 1;
            @(posedge clk);

            @(negedge clk);
            load = 0;
            serial_in = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Shift Left (serial_in=1)");
            reset_dut();

            @(negedge clk);
            parallel_in = 8'h0F;
            load = 1;
            @(posedge clk);

            @(negedge clk);
            load = 0;
            serial_in = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h1F);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Multiple Shifts (Fill with 1s)");
            reset_dut();
            @(negedge clk);
            load = 0;
            serial_in = 1;

            repeat (8) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Shift out MSB");
            reset_dut();

            @(negedge clk);
            parallel_in = 8'h80;
            load = 1;
            @(posedge clk);

            @(negedge clk);
            load = 0;
            serial_in = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Load priority");
            reset_dut();
            @(negedge clk);
            parallel_in = 8'hCC;
            load = 1;
            serial_in = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hCC);
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
        $dumpvars(0,clk, load, parallel_in, rst, serial_in, data_out);
    end

endmodule
