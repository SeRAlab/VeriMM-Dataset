`timescale 1ns/1ps

module shift_register_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg load;
    reg rst;
    reg shift_in;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_32bit dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .rst(rst),
        .shift_in(shift_in),
        .data_out(data_out)
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
            data_in = 0;
            shift_in = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Basic Reset...");
            reset_dut();

            #1;


            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Parallel Load...");
            reset_dut();
            data_in = 32'hA5A5_5A5A;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(32'hA5A5_5A5A);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Single Shift Operation...");
            reset_dut();

            data_in = 32'h0000_0001;
            load = 1;
            @(posedge clk);

            #1 load = 0;
            shift_in = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h8000_0000);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Multi-bit Shift Sequence...");
            reset_dut();
            shift_in = 1;
            load = 0;

            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(32'hF000_0000);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Load Priority over Shift...");
            reset_dut();
            data_in = 32'h1234_5678;
            load = 1;
            shift_in = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Reset Priority...");
            reset_dut();
            rst = 1;
            load = 1;
            data_in = 32'hFFFF_FFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0000_0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_32bit Testbench");
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
        input [31:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, load, rst, shift_in, data_out);
    end

endmodule
