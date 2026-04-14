`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [8:0] address_a;
    reg [8:0] address_b;
    reg clock_a;
    reg clock_b;
    reg [7:0] data_a;
    reg [7:0] data_b;
    reg wren_a;
    reg wren_b;
    wire [7:0] q_a;
    wire [7:0] q_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address_a(address_a),
        .address_b(address_b),
        .clock_a(clock_a),
        .clock_b(clock_b),
        .data_a(data_a),
        .data_b(data_b),
        .wren_a(wren_a),
        .wren_b(wren_b),
        .q_a(q_a),
        .q_b(q_b)
    );

    // Clock generation (10ns period)
    initial begin
        clock_a = 0;
        forever #5 clock_a = ~clock_a;
    end

        task reset_dut;

        begin
            address_a = 0;
            address_b = 0;
            data_a = 0;
            data_b = 0;
            wren_a = 0;
            wren_b = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Port A Basic Write/Read", test_num);
            reset_dut();
            @(posedge clock_a);
            address_a = 9'h010;
            data_a = 8'hA5;
            wren_a = 1;
            @(posedge clock_a);
            wren_a = 0;
            address_a = 9'h010;
            @(posedge clock_a);
            #1;
            #1;

            check_outputs(8'hA5, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Port B Basic Write/Read", test_num);
            reset_dut();
            @(posedge clock_b);
            address_b = 9'h020;
            data_b = 8'h5A;
            wren_b = 1;
            @(posedge clock_b);
            wren_b = 0;
            address_b = 9'h020;
            @(posedge clock_b);
            #1;
            #1;

            check_outputs(8'h00, 8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Cross-Port Access (Write A, Read B)", test_num);
            reset_dut();
            @(posedge clock_a);
            address_a = 9'h030;
            data_a = 8'hCC;
            wren_a = 1;
            @(posedge clock_a);
            wren_a = 0;
            @(posedge clock_b);
            address_b = 9'h030;
            @(posedge clock_b);
            #1;
            #1;

            check_outputs(8'h00, 8'hCC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Writes to Different Addresses", test_num);
            reset_dut();
            @(posedge clock_a);

            address_a = 9'h040; data_a = 8'h44; wren_a = 1;
            address_b = 9'h050; data_b = 8'h55; wren_b = 1;
            @(posedge clock_a);
            wren_a = 0; wren_b = 0;

            address_a = 9'h040;
            address_b = 9'h050;
            @(posedge clock_a);
            #1;
            #1;

            check_outputs(8'h44, 8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Addresses (0 and 511)", test_num);
            reset_dut();

            @(posedge clock_a);
            address_a = 9'h000; data_a = 8'h01; wren_a = 1;
            @(posedge clock_a);
            wren_a = 0;

            @(posedge clock_b);
            address_b = 9'h1FF; data_b = 8'hFF; wren_b = 1;
            @(posedge clock_b);
            wren_b = 0;

            address_a = 9'h000;
            address_b = 9'h1FF;
            @(posedge clock_a);
            #1;
            #1;

            check_outputs(8'h01, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Read from Same Address", test_num);
            reset_dut();

            @(posedge clock_a);
            address_a = 9'h100; data_a = 8'h77; wren_a = 1;
            @(posedge clock_a);
            wren_a = 0;

            address_a = 9'h100;
            address_b = 9'h100;
            @(posedge clock_a);
            #1;
            #1;

            check_outputs(8'h77, 8'h77);
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
        input [7:0] expected_q_a;
        input [7:0] expected_q_b;
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
        $dumpvars(0,address_a, address_b, clock_a, clock_b, data_a, data_b, wren_a, wren_b, q_a, q_b);
    end

endmodule
