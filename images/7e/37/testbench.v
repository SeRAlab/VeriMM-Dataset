`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] addr_i;
    reg clk_i;
    reg [31:0] data_i;
    reg read_i;
    reg reset_i;
    reg write_i;
    wire [31:0] data_o;
    wire [79:0] keys;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_i(addr_i),
        .clk_i(clk_i),
        .data_i(data_i),
        .read_i(read_i),
        .reset_i(reset_i),
        .write_i(write_i),
        .data_o(data_o),
        .keys(keys)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            reset_i = 1;
            addr_i = 0;
            write_i = 0;
            read_i = 0;
            data_i = 0;
            @(posedge clk_i);
            #2 reset_i = 0;
            @(posedge clk_i);
            #2;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset state verification");
            reset_dut();

            #1;


            check_outputs(32'h0, 80'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Write and Read Region 0 (bits 31:0)");
            reset_dut();
            @(posedge clk_i);
            addr_i = 6'd0;
            data_i = 32'hDEADBEEF;
            write_i = 1;
            @(posedge clk_i);
            write_i = 0;
            read_i = 1;
            @(posedge clk_i);
            read_i = 0;
            #1;

            check_outputs(32'hDEADBEEF, {48'h0, 32'hDEADBEEF});
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write and Read Region 1 (bits 63:32)");
            reset_dut();
            @(posedge clk_i);
            addr_i = 6'd1;
            data_i = 32'hCAFEBABE;
            write_i = 1;
            @(posedge clk_i);
            write_i = 0;
            read_i = 1;
            @(posedge clk_i);
            read_i = 0;
            #1;

            check_outputs(32'hCAFEBABE, {16'h0, 32'hCAFEBABE, 32'h0});
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Write and Read Region 2 (bits 79:64)");
            reset_dut();
            @(posedge clk_i);
            addr_i = 6'd2;
            data_i = 32'h00001234;
            write_i = 1;
            @(posedge clk_i);
            write_i = 0;
            read_i = 1;
            @(posedge clk_i);
            read_i = 0;


            #1;



            check_outputs(32'h00001234, {16'h1234, 32'h0, 32'h0});
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Full 80-bit key construction");
            reset_dut();


            @(posedge clk_i);
            addr_i = 6'd0; data_i = 32'h11111111; write_i = 1;
            @(posedge clk_i);


            addr_i = 6'd1; data_i = 32'h22222222; write_i = 1;
            @(posedge clk_i);


            addr_i = 6'd2; data_i = 32'h00003333; write_i = 1;
            @(posedge clk_i);


            write_i = 0;
            addr_i = 6'd0; read_i = 1;
            @(posedge clk_i);
            read_i = 0;

            #1;


            check_outputs(32'h11111111, {16'h3333, 32'h22222222, 32'h11111111});
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
        input [31:0] expected_data_o;
        input [79:0] expected_keys;
        begin
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o) &&
                expected_keys === (expected_keys ^ keys ^ expected_keys)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h, keys=%h",
                         data_o, keys);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h, keys=%h",
                         expected_data_o, expected_keys);
                $display("  Got:      data_o=%h, keys=%h",
                         data_o, keys);
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
        $dumpvars(0,addr_i, clk_i, data_i, read_i, reset_i, write_i, data_o, keys);
    end

endmodule
