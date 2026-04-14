`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] address_a;
    reg [9:0] address_b;
    reg [1:0] byteena_a;
    reg [1:0] byteena_b;
    reg clock;
    reg [15:0] data_a;
    reg [15:0] data_b;
    reg wren_a;
    reg wren_b;
    wire [15:0] q_a;
    wire [15:0] q_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address_a(address_a),
        .address_b(address_b),
        .byteena_a(byteena_a),
        .byteena_b(byteena_b),
        .clock(clock),
        .data_a(data_a),
        .data_b(data_b),
        .wren_a(wren_a),
        .wren_b(wren_b),
        .q_a(q_a),
        .q_b(q_b)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            address_a = 0;
            address_b = 0;
            byteena_a = 2'b00;
            byteena_b = 2'b00;
            data_a = 0;
            data_b = 0;
            wren_a = 0;
            wren_b = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Port A Write/Read");
            reset_dut();


            address_a = 10'd10;
            data_a = 16'hA5A5;
            wren_a = 1'b1;
            byteena_a = 2'b11;
            @(posedge clock);


            wren_a = 1'b0;
            address_a = 10'd10;
            @(posedge clock);
            #1;

            #1;


            check_outputs(16'hA5A5, q_b);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Port B Write/Read");
            reset_dut();


            address_b = 10'd20;
            data_b = 16'h5A5A;
            wren_b = 1'b1;
            byteena_b = 2'b11;
            @(posedge clock);


            wren_b = 1'b0;
            address_b = 10'd20;
            @(posedge clock);
            #1;

            #1;


            check_outputs(q_a, 16'h5A5A);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Port A Byte Enable (Lower Byte)");
            reset_dut();


            address_a = 10'd30;
            data_a = 16'h0000;
            wren_a = 1'b1;
            byteena_a = 2'b11;
            @(posedge clock);


            data_a = 16'hFFFF;
            byteena_a = 2'b01;
            @(posedge clock);

            wren_a = 1'b0;
            address_a = 10'd30;
            @(posedge clock);
            #1;

            #1;


            check_outputs(16'h00FF, q_b);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Port B Byte Enable (Upper Byte)");
            reset_dut();


            address_b = 10'd40;
            data_b = 16'h0000;
            wren_b = 1'b1;
            byteena_b = 2'b11;
            @(posedge clock);


            data_b = 16'hEEEE;
            byteena_b = 2'b10;
            @(posedge clock);

            wren_b = 1'b0;
            address_b = 10'd40;
            @(posedge clock);
            #1;

            #1;


            check_outputs(q_a, 16'hEE00);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Dual Port Simultaneous Write");
            reset_dut();


            address_a = 10'd100; data_a = 16'h1111; wren_a = 1'b1; byteena_a = 2'b11;
            address_b = 10'd200; data_b = 16'h2222; wren_b = 1'b1; byteena_b = 2'b11;
            @(posedge clock);


            wren_a = 1'b0; wren_b = 1'b0;
            address_a = 10'd100;
            address_b = 10'd200;
            @(posedge clock);
            #1;

            #1;


            check_outputs(16'h1111, 16'h2222);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Dual Port Simultaneous Read");
            reset_dut();


            address_a = 10'd500; data_a = 16'hAAAA; wren_a = 1'b1; byteena_a = 2'b11;
            address_b = 10'd600; data_b = 16'hBBBB; wren_b = 1'b1; byteena_b = 2'b11;
            @(posedge clock);


            wren_a = 1'b0; wren_b = 1'b0;
            address_a = 10'd600;
            address_b = 10'd500;
            @(posedge clock);
            #1;

            #1;


            check_outputs(16'hBBBB, 16'hAAAA);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Sequential Byte-wise Write Port A");
            reset_dut();

            address_a = 10'd700;
            wren_a = 1'b1;


            data_a = 16'h1234;
            byteena_a = 2'b01;
            @(posedge clock);


            data_a = 16'hABCD;
            byteena_a = 2'b10;
            @(posedge clock);


            wren_a = 1'b0;
            address_a = 10'd700;
            @(posedge clock);
            #1;


            #1;



            check_outputs(16'hAB34, q_b);
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
        input [15:0] expected_q_a;
        input [15:0] expected_q_b;
        begin
            if (expected_q_a === (expected_q_a ^ q_a ^ expected_q_a) &&
                expected_q_b === (expected_q_b ^ q_b ^ expected_q_b)) begin
                $display("PASS");
                $display("  Outputs: q_a=%h, q_b=%h",
                         q_a, q_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q_a=%h, q_b=%h",
                         expected_q_a, expected_q_b);
                $display("  Got:      q_a=%h, q_b=%h",
                         q_a, q_b);
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
        $dumpvars(0,address_a, address_b, byteena_a, byteena_b, clock, data_a, data_b, wren_a, wren_b, q_a, q_b);
    end

endmodule
