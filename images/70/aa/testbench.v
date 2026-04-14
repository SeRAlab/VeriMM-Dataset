`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] address_a;
    reg [6:0] address_b;
    reg clock;
    reg [7:0] wrdata_a;
    reg [7:0] wrdata_b;
    reg wren_a;
    reg wren_b;
    wire [7:0] rddata_a;
    wire [7:0] rddata_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address_a(address_a),
        .address_b(address_b),
        .clock(clock),
        .wrdata_a(wrdata_a),
        .wrdata_b(wrdata_b),
        .wren_a(wren_a),
        .wren_b(wren_b),
        .rddata_a(rddata_a),
        .rddata_b(rddata_b)
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
            wrdata_a = 0;
            wrdata_b = 0;
            wren_a = 0;
            wren_b = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read on Port A", test_num);
            reset_dut();


            address_a <= 7'h10;
            wrdata_a <= 8'h55;
            wren_a <= 1;
            @(posedge clock);


            wren_a <= 0;
            address_a <= 7'h10;
            @(posedge clock);

            #1;
            #1;

            check_outputs(8'h55, 8'hxx);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Write and Read on Port B", test_num);
            reset_dut();


            address_b <= 7'h20;
            wrdata_b <= 8'hAA;
            wren_b <= 1;
            @(posedge clock);


            wren_b <= 0;
            address_b <= 7'h20;
            @(posedge clock);

            #1;
            #1;

            check_outputs(8'hxx, 8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Simultaneous Writes to Different Addresses", test_num);
            reset_dut();


            address_a <= 7'h30; wrdata_a <= 8'h11; wren_a <= 1;
            address_b <= 7'h31; wrdata_b <= 8'h22; wren_b <= 1;
            @(posedge clock);


            wren_a <= 0; wren_b <= 0;
            address_a <= 7'h30;
            address_b <= 7'h31;
            @(posedge clock);

            #1;
            #1;

            check_outputs(8'h11, 8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Simultaneous Reads from the Same Address", test_num);
            reset_dut();


            address_a <= 7'h40;
            wrdata_a <= 8'hCC;
            wren_a <= 1;
            @(posedge clock);


            wren_a <= 0;
            address_a <= 7'h40;
            address_b <= 7'h40;
            @(posedge clock);

            #1;
            #1;

            check_outputs(8'hCC, 8'hCC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Boundary Address (127) and Data (0xFF)", test_num);
            reset_dut();


            address_a <= 7'h7F;
            wrdata_a <= 8'hFF;
            wren_a <= 1;
            address_b <= 7'h00;
            wrdata_b <= 0;
            wren_b <= 1;
            @(posedge clock);


            wren_a <= 0;
            wren_b <= 0;
            address_a <= 7'h7F;
            address_b <= 7'h00;
            @(posedge clock);

            #1;
            #1;

            check_outputs(8'hFF, 8'h00);
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
        input [7:0] expected_rddata_a;
        input [7:0] expected_rddata_b;
        begin
            if (expected_rddata_a === (expected_rddata_a ^ rddata_a ^ expected_rddata_a) &&
                expected_rddata_b === (expected_rddata_b ^ rddata_b ^ expected_rddata_b)) begin
                $display("PASS");
                $display("  Outputs: rddata_a=%h, rddata_b=%h",
                         rddata_a, rddata_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rddata_a=%h, rddata_b=%h",
                         expected_rddata_a, expected_rddata_b);
                $display("  Got:      rddata_a=%h, rddata_b=%h",
                         rddata_a, rddata_b);
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
        $dumpvars(0,address_a, address_b, clock, wrdata_a, wrdata_b, wren_a, wren_b, rddata_a, rddata_b);
    end

endmodule
