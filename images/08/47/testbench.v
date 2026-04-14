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
            data_in = 0;
            write_enable = 0;
            read_enable = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Initial state after reset");
            test_num = 1;
            reset_dut();
            read_enable = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(5'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Simple Write and Read (5'h1A)");
            test_num = 2;
            reset_dut();


            data_in = 5'h1A;
            write_enable = 1;
            @(posedge clk);
            #1 write_enable = 0;


            read_enable = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(5'h1A);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Verify read_enable gating");
            test_num = 3;
            reset_dut();


            data_in = 5'h0F;
            write_enable = 1;
            @(posedge clk);
            #1 write_enable = 0;


            read_enable = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(5'h00);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Overwriting data");
            test_num = 4;
            reset_dut();


            data_in = 5'h05;
            write_enable = 1;
            @(posedge clk);
            #1;


            data_in = 5'h12;
            write_enable = 1;
            @(posedge clk);
            #1 write_enable = 0;


            read_enable = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(5'h12);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Data stability without write_enable");
            test_num = 5;
            reset_dut();


            data_in = 5'h0A;
            write_enable = 1;
            @(posedge clk);
            #1 write_enable = 0;


            data_in = 5'h1F;
            @(posedge clk);


            read_enable = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(5'h0A);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Simultaneous Read and Write");
            test_num = 6;
            reset_dut();


            data_in = 5'h15;
            write_enable = 1;
            read_enable = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(5'h15);
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
