`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data_in;
    reg read_enable;
    reg rst;
    reg write_enable;
    wire [4:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .data_in(data_in),
        .read_enable(read_enable),
        .rst(rst),
        .write_enable(write_enable),
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
            data_in = 5'b0;
            read_enable = 0;
            write_enable = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read");
            reset_dut();
            test_num = 1;


            data_in = 5'h12;
            write_enable = 1;
            @(posedge clk);
            #1;
            write_enable = 0;


            read_enable = 1;
            #5;
            #1;

            check_outputs(5'h12);
            read_enable = 0;
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Write and Read Boundary Value (All 1s)");
            reset_dut();
            test_num = 2;

            data_in = 5'h1F;
            write_enable = 1;
            @(posedge clk);
            #1;
            write_enable = 0;

            read_enable = 1;
            #5;
            #1;

            check_outputs(5'h1F);
            read_enable = 0;
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Check Reset Default Value");
            reset_dut();
            test_num = 3;


            read_enable = 1;
            #5;
            #1;

            check_outputs(5'h00);
            read_enable = 0;
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Verify Write Enable is required to change register");
            reset_dut();
            test_num = 4;


            data_in = 5'h0A;
            write_enable = 1;
            @(posedge clk);
            #1;


            data_in = 5'h15;
            write_enable = 0;
            @(posedge clk);
            #1;


            read_enable = 1;
            #5;
            #1;

            check_outputs(5'h0A);
            read_enable = 0;
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Consecutive Writes check");
            reset_dut();
            test_num = 5;


            data_in = 5'h01;
            write_enable = 1;
            @(posedge clk);
            #1;


            data_in = 5'h02;
            @(posedge clk);
            #1;


            data_in = 5'h03;
            @(posedge clk);
            #1;
            write_enable = 0;


            read_enable = 1;
            #5;
            #1;

            check_outputs(5'h03);
            read_enable = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gpio_controller Testbench");
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
        input [4:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, read_enable, rst, write_enable, data_out);
    end

endmodule
