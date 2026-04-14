`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [7:0] d8_chr;
    wire [13:0] addr;
    wire [4:0] b;
    wire [5:0] g;
    wire hs;
    wire [4:0] r;
    wire vs;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .d8_chr(d8_chr),
        .addr(addr),
        .b(b),
        .g(g),
        .hs(hs),
        .r(r),
        .vs(vs)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            d8_chr = 8'h00;


            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            repeat(2) @(posedge clock);


            #1;



            check_outputs(14'h0002, 5'h00, 6'h00, 1'b1, 5'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            repeat(100) @(posedge clock);

            #1;


            check_outputs(14'h0064, 5'h00, 6'h00, 1'b1, 5'h00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            repeat(700) @(posedge clock);


            if (hs === 1'b0) begin
                pass_count = pass_count + 1;
                $display("PASS: HS logic correctly entered Sync Pulse (0) at cycle 700");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: HS logic failed to enter Sync Pulse (Expected 0, Got %b)", hs);
            end
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            d8_chr = 8'hFF;
            repeat(5) @(posedge clock);


            #1;



            check_outputs(14'h0005, 5'h1F, 6'h3F, 1'b1, 5'h1F, 1'b1);
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
        input [13:0] expected_addr;
        input [4:0] expected_b;
        input [5:0] expected_g;
        input expected_hs;
        input [4:0] expected_r;
        input expected_vs;
        begin
            if (expected_addr === (expected_addr ^ addr ^ expected_addr) &&
                expected_b === (expected_b ^ b ^ expected_b) &&
                expected_g === (expected_g ^ g ^ expected_g) &&
                expected_hs === (expected_hs ^ hs ^ expected_hs) &&
                expected_r === (expected_r ^ r ^ expected_r) &&
                expected_vs === (expected_vs ^ vs ^ expected_vs)) begin
                $display("PASS");
                $display("  Outputs: addr=%h, b=%h, g=%h, hs=%b, r=%h, vs=%b",
                         addr, b, g, hs, r, vs);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr=%h, b=%h, g=%h, hs=%b, r=%h, vs=%b",
                         expected_addr, expected_b, expected_g, expected_hs, expected_r, expected_vs);
                $display("  Got:      addr=%h, b=%h, g=%h, hs=%b, r=%h, vs=%b",
                         addr, b, g, hs, r, vs);
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
        $dumpvars(0,clock, d8_chr, addr, b, g, hs, r, vs);
    end

endmodule
