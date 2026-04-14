`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] address_a;
    reg [11:0] address_b;
    reg clock;
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
        address_a = 12'd0;
        address_b = 12'd0;
        data_a = 8'd0;
        data_b = 8'd0;
        wren_a = 1'b0;
        wren_b = 1'b0;
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Simultaneous Write to Different Addresses");
        test_num = test_num + 1;
        reset_dut();


        address_a = 12'h010; data_a = 8'hAA; wren_a = 1;
        address_b = 12'h020; data_b = 8'h55; wren_b = 1;
        @(posedge clock);
        #1;


        wren_a = 0; wren_b = 0;
        address_a = 12'h010; address_b = 12'h020;
        @(posedge clock);
        #1;
        #1;

        check_outputs(8'hAA, 8'h55);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Cross-port Verification");
        test_num = test_num + 1;
        reset_dut();


        address_a = 12'hF00; data_a = 8'hDE; wren_a = 1;
        @(posedge clock);
        #1;


        wren_a = 0;
        address_b = 12'hF00;
        @(posedge clock);
        #1;


        #1;



        check_outputs(q_a, 8'hDE);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Simultaneous Read from Same Address");
        test_num = test_num + 1;
        reset_dut();


        address_a = 12'h500; data_a = 8'h69; wren_a = 1;
        @(posedge clock);
        #1;


        wren_a = 0;
        address_a = 12'h500;
        address_b = 12'h500;
        @(posedge clock);
        #1;

        #1;


        check_outputs(8'h69, 8'h69);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Write Enable Logic Verification");
        test_num = test_num + 1;
        reset_dut();


        address_a = 12'h777; data_a = 8'h11; wren_a = 1;
        @(posedge clock);
        #1;


        wren_a = 0;
        data_a = 8'h99;
        @(posedge clock);
        #1;


        address_a = 12'h777;
        @(posedge clock);
        #1;
        #1;

        check_outputs(8'h11, q_b);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Boundary Check (Address 0xFFF, Data 0xFF)");
        test_num = test_num + 1;
        reset_dut();


        address_a = 12'hFFF; data_a = 8'hFF; wren_a = 1;
        address_b = 12'h000; data_b = 8'h01; wren_b = 1;
        @(posedge clock);
        #1;

        wren_a = 0; wren_b = 0;
        address_a = 12'hFFF;
        address_b = 12'h000;
        @(posedge clock);
        #1;

        #1;


        check_outputs(8'hFF, 8'h01);
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
        $dumpvars(0,address_a, address_b, clock, data_a, data_b, wren_a, wren_b, q_a, q_b);
    end

endmodule
