`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] address;
    reg [15:0] data_in;
    reg [7:0] output_AB;
    reg write;
    wire [15:0] data_out_A;
    wire [15:0] data_out_B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .data_in(data_in),
        .output_AB(output_AB),
        .write(write),
        .data_out_A(data_out_A),
        .data_out_B(data_out_B)
    );

    // Clock generation (10ns period)
    initial begin
        write = 0;
        forever #5 write = ~write;
    end

        task reset_dut;

        begin
            address = 4'd0;
            data_in = 16'd0;
            output_AB = 8'd0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase 001: Checking Register 0 hardwired to zero...");
            address = 4'd0;
            data_in = 16'hFFFF;
            output_AB = 8'h00;
            #10;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase 002: Basic write/read to Register 1...");
            address = 4'd1;
            data_in = 16'hAAAA;
            #10;
            output_AB = 8'h11;
            #5;
            #1;

            check_outputs(16'hAAAA, 16'hAAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase 003: Dual port reading (Reg 5 and Reg 10)...");

            address = 4'd5; data_in = 16'h5555; #10;

            address = 4'd10; data_in = 16'h1010; #10;

            output_AB = 8'h5A;
            #5;
            #1;

            check_outputs(16'h5555, 16'h1010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase 004: Overwriting Register 2...");
            address = 4'd2; data_in = 16'h1234; #10;
            address = 4'd2; data_in = 16'h5678; #10;
            output_AB = 8'h22;
            #5;
            #1;

            check_outputs(16'h5678, 16'h5678);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase 005: Boundary check Register 15...");
            address = 4'd15; data_in = 16'hF0F0; #10;
            address = 4'd3;  data_in = 16'h3333; #10;
            output_AB = 8'hF3;
            #5;
            #1;

            check_outputs(16'hF0F0, 16'h3333);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [15:0] expected_data_out_A;
        input [15:0] expected_data_out_B;
        begin
            if (expected_data_out_A === (expected_data_out_A ^ data_out_A ^ expected_data_out_A) &&
                expected_data_out_B === (expected_data_out_B ^ data_out_B ^ expected_data_out_B)) begin
                $display("PASS");
                $display("  Outputs: data_out_A=%h, data_out_B=%h",
                         data_out_A, data_out_B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out_A=%h, data_out_B=%h",
                         expected_data_out_A, expected_data_out_B);
                $display("  Got:      data_out_A=%h, data_out_B=%h",
                         data_out_A, data_out_B);
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
        $dumpvars(0,address, data_in, output_AB, write, data_out_A, data_out_B);
    end

endmodule
