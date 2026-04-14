`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] address_a;
    reg [7:0] address_b;
    reg clock;
    reg [35:0] data_a;
    reg [35:0] data_b;
    reg rden_a;
    reg rden_b;
    reg wren_a;
    reg wren_b;
    wire [35:0] q_a;
    wire [35:0] q_b;

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
        .rden_a(rden_a),
        .rden_b(rden_b),
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
            address_a <= 8'h0;
            address_b <= 8'h0;
            data_a <= 36'h0;
            data_b <= 36'h0;
            rden_a <= 1'b0;
            rden_b <= 1'b0;
            wren_a <= 1'b0;
            wren_b <= 1'b0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Port A Basic Write/Read", test_num);
            reset_dut();


            address_a <= 8'h0A;
            data_a <= 36'hA1B2C3D4E;
            wren_a <= 1'b1;
            @(posedge clock);
            #1;


            wren_a <= 1'b0;
            rden_a <= 1'b1;
            @(posedge clock);
            #1;


            #1;



            check_outputs(36'hA1B2C3D4E, 36'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Port B Basic Write/Read", test_num);
            reset_dut();


            address_b <= 8'hFF;
            data_b <= 36'hF0F0F0F0F;
            wren_b <= 1'b1;
            @(posedge clock);
            #1;


            wren_b <= 1'b0;
            rden_b <= 1'b1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(36'h0, 36'hF0F0F0F0F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Simultaneous Dual Port Operations", test_num);
            reset_dut();


            address_a <= 8'h10;
            data_a <= 36'h111111111;
            wren_a <= 1'b1;

            address_b <= 8'h20;
            data_b <= 36'h222222222;
            wren_b <= 1'b1;
            @(posedge clock);
            #1;


            wren_a <= 1'b0;
            wren_b <= 1'b0;
            rden_a <= 1'b1;
            rden_b <= 1'b1;
            address_a <= 8'h10;
            address_b <= 8'h20;
            @(posedge clock);
            #1;

            #1;


            check_outputs(36'h111111111, 36'h222222222);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Simultaneous Read from Same Address", test_num);
            reset_dut();


            address_a <= 8'h55;
            data_a <= 36'h55AA55AA5;
            wren_a <= 1'b1;
            @(posedge clock);
            #1;


            wren_a <= 1'b0;
            rden_a <= 1'b1;
            rden_b <= 1'b1;
            address_a <= 8'h55;
            address_b <= 8'h55;
            @(posedge clock);
            #1;

            #1;


            check_outputs(36'h55AA55AA5, 36'h55AA55AA5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Write Enable Inhibition Check", test_num);
            reset_dut();


            address_a <= 8'hAA;
            data_a <= 36'hFFFFFFFFF;
            wren_a <= 1'b0;
            @(posedge clock);
            #1;


            rden_a <= 1'b1;
            @(posedge clock);
            #1;


            if (q_a !== 36'hFFFFFFFFF) begin
                $display("PASS: Write prevented as expected.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Write occurred even though wren was low.");
                fail_count = fail_count + 1;
            end
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
        input [35:0] expected_q_a;
        input [35:0] expected_q_b;
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
        $dumpvars(0,address_a, address_b, clock, data_a, data_b, rden_a, rden_b, wren_a, wren_b, q_a, q_b);
    end

endmodule
