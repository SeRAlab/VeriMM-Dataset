`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr_a;
    reg [3:0] addr_b;
    reg clk_a;
    reg clk_b;
    reg [3:0] data_a;
    reg [3:0] data_b;
    reg en_a;
    reg en_b;
    reg we_a;
    reg we_b;
    wire [3:0] data_out_a;
    wire [3:0] data_out_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_a(addr_a),
        .addr_b(addr_b),
        .clk_a(clk_a),
        .clk_b(clk_b),
        .data_a(data_a),
        .data_b(data_b),
        .en_a(en_a),
        .en_b(en_b),
        .we_a(we_a),
        .we_b(we_b),
        .data_out_a(data_out_a),
        .data_out_b(data_out_b)
    );

    // Clock generation (10ns period)
    initial begin
        clk_a = 0;
        forever #5 clk_a = ~clk_a;
    end

        task reset_dut;

    begin
        en_a = 0; en_b = 0; we_a = 0; we_b = 0;
        addr_a = 0; addr_b = 0; data_a = 0; data_b = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Port A Basic Write and Read", test_num);
        reset_dut();
        @(posedge clk_a);
        en_a = 1; we_a = 1; addr_a = 4'h1; data_a = 4'hA;
        @(posedge clk_a);
        we_a = 0; addr_a = 4'h1;
        @(posedge clk_a);
        #1;
        #1;

        check_outputs(4'hA, data_out_b);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Port B Basic Write and Read", test_num);
        reset_dut();
        @(posedge clk_b);
        en_b = 1; we_b = 1; addr_b = 4'h3; data_b = 4'h5;
        @(posedge clk_b);
        we_b = 0; addr_b = 4'h3;
        @(posedge clk_b);
        #1;
        #1;

        check_outputs(data_out_a, 4'h5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Port A Enable Test (Write disabled when en=0)", test_num);
        reset_dut();

        @(posedge clk_a);
        en_a = 1; we_a = 1; addr_a = 4'h0; data_a = 4'hF;
        @(posedge clk_a);

        en_a = 0; we_a = 1; data_a = 4'h0;
        @(posedge clk_a);

        en_a = 1; we_a = 0; addr_a = 4'h0;
        @(posedge clk_a);
        #1;
        #1;

        check_outputs(4'hF, data_out_b);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Port B Write Enable Test (Write disabled when we=0)", test_num);
        reset_dut();

        @(posedge clk_b);
        en_b = 1; we_b = 1; addr_b = 4'h2; data_b = 4'h7;
        @(posedge clk_b);

        en_b = 1; we_b = 0; data_b = 4'hE;
        @(posedge clk_b);

        en_b = 1; we_b = 0; addr_b = 4'h2;
        @(posedge clk_b);
        #1;
        #1;

        check_outputs(data_out_a, 4'h7);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Simultaneous Dual Port Operation", test_num);
        reset_dut();
        @(posedge clk_a);

        en_a = 1; we_a = 1; addr_a = 4'h0; data_a = 4'h2;
        en_b = 1; we_b = 1; addr_b = 4'h1; data_b = 4'hD;
        @(posedge clk_a);

        we_a = 0; addr_a = 4'h0;
        we_b = 0; addr_b = 4'h1;
        @(posedge clk_a);
        #1;
        #1;

        check_outputs(4'h2, 4'hD);
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
        input [3:0] expected_data_out_a;
        input [3:0] expected_data_out_b;
        begin
            if (expected_data_out_a === (expected_data_out_a ^ data_out_a ^ expected_data_out_a) &&
                expected_data_out_b === (expected_data_out_b ^ data_out_b ^ expected_data_out_b)) begin
                $display("PASS");
                $display("  Outputs: data_out_a=%h, data_out_b=%h",
                         data_out_a, data_out_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out_a=%h, data_out_b=%h",
                         expected_data_out_a, expected_data_out_b);
                $display("  Got:      data_out_a=%h, data_out_b=%h",
                         data_out_a, data_out_b);
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
        $dumpvars(0,addr_a, addr_b, clk_a, clk_b, data_a, data_b, en_a, en_b, we_a, we_b, data_out_a, data_out_b);
    end

endmodule
