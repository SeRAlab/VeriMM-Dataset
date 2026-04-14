`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] address_a;
    reg [4:0] address_b;
    reg clock;
    reg [31:0] data_a;
    reg [31:0] data_b;
    reg rd_en_a;
    reg rd_en_b;
    reg wren_a;
    reg wren_b;
    wire [31:0] q_a;
    wire [31:0] q_b;

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
        .rd_en_a(rd_en_a),
        .rd_en_b(rd_en_b),
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
        data_a = 0;
        data_b = 0;
        rd_en_a = 0;
        rd_en_b = 0;
        wren_a = 0;
        wren_b = 0;
        @(negedge clock);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Port A Write and Read", test_num);
        reset_dut();

        address_a = 5'h05; data_a = 32'hA5A5A5A5; wren_a = 1;
        @(negedge clock);

        wren_a = 0; rd_en_a = 1; address_a = 5'h05;
        @(negedge clock);
        #1;
        #1;

        check_outputs(32'hA5A5A5A5, 32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Port B Write and Read", test_num);
        reset_dut();

        address_b = 5'h0A; data_b = 32'h5A5A5A5A; wren_b = 1;
        @(negedge clock);

        wren_b = 0; rd_en_b = 1; address_b = 5'h0A;
        @(negedge clock);
        #1;
        #1;

        check_outputs(32'h0, 32'h5A5A5A5A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Concurrent Writes to Port A and B", test_num);
        reset_dut();

        address_a = 5'h01; data_a = 32'h11111111; wren_a = 1;
        address_b = 5'h02; data_b = 32'h22222222; wren_b = 1;
        @(negedge clock);

        wren_a = 0; rd_en_a = 1; address_a = 5'h01;
        wren_b = 0; rd_en_b = 1; address_b = 5'h02;
        @(negedge clock);
        #1;
        #1;

        check_outputs(32'h11111111, 32'h22222222);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Port A Read during Port B Write", test_num);
        reset_dut();

        address_a = 5'h0F; data_a = 32'hBEEFBEEF; wren_a = 1;
        @(negedge clock);

        wren_a = 0; rd_en_a = 1; address_a = 5'h0F;
        wren_b = 1; address_b = 5'h10; data_b = 32'hCAFECAFE;
        @(negedge clock);
        #1;
        #1;

        check_outputs(32'hBEEFBEEF, 32'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Boundary Address Check (0 and 31)", test_num);
        reset_dut();

        address_a = 5'd0;  data_a = 32'h00000001; wren_a = 1;
        address_b = 5'd31; data_b = 32'h80000000; wren_b = 1;
        @(negedge clock);

        wren_a = 0; rd_en_a = 1; address_a = 5'd0;
        wren_b = 0; rd_en_b = 1; address_b = 5'd31;
        @(negedge clock);
        #1;
        #1;

        check_outputs(32'h00000001, 32'h80000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Verify rd_en Control", test_num);
        reset_dut();

        address_a = 5'h15; data_a = 32'hFFFFFFFF; wren_a = 1;
        @(negedge clock);

        wren_a = 0; rd_en_a = 0; address_a = 5'h15;
        @(negedge clock);
        #1;




        if (q_a !== 32'hFFFFFFFF) begin
            $display("PASS: Data not read when rd_en is low");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: Data read even when rd_en is low");
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
        input [31:0] expected_q_a;
        input [31:0] expected_q_b;
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
        $dumpvars(0,address_a, address_b, clock, data_a, data_b, rd_en_a, rd_en_b, wren_a, wren_b, q_a, q_b);
    end

endmodule
