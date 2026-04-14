`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data_in;
    reg [4:0] data_out_en;
    reg [4:0] dir;
    reg rst;
    wire [4:0] data_in_read;
    wire [4:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .data_in(data_in),
        .data_out_en(data_out_en),
        .dir(dir),
        .rst(rst),
        .data_in_read(data_in_read),
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
            data_out_en = 5'b0;
            dir = 5'b0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Reset State Check");
            #1;

            check_outputs(5'h00, 5'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: All Pins Output Mode");
            dir = 5'b11111;
            data_out_en = 5'b10101;
            @(posedge clk);
            #1;


            #1;



            check_outputs(5'h00, 5'h15);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: All Pins Input Mode");
            dir = 5'b00000;
            data_in = 5'b11011;
            @(posedge clk);
            #1;

            #1;


            check_outputs(5'h1B, 5'h00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Mixed Configuration");
            dir = 5'b00111;
            data_out_en = 5'b11111;
            data_in = 5'b11000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h18, 5'h07);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Dynamic Direction Switching");


            dir = 5'b00000;
            data_in = 5'b11111;
            @(posedge clk);


            dir = 5'b11111;
            data_out_en = 5'b01010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h00, 5'h0A);
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
        input [4:0] expected_data_in_read;
        input [4:0] expected_data_out;
        begin
            if (expected_data_in_read === (expected_data_in_read ^ data_in_read ^ expected_data_in_read) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_in_read=%h, data_out=%h",
                         data_in_read, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_in_read=%h, data_out=%h",
                         expected_data_in_read, expected_data_out);
                $display("  Got:      data_in_read=%h, data_out=%h",
                         data_in_read, data_out);
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
        $dumpvars(0,clk, data_in, data_out_en, dir, rst, data_in_read, data_out);
    end

endmodule
