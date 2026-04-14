`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] addr_port1;
    reg [15:0] addr_port2;
    reg clk;
    reg [15:0] data_in_port1;
    reg [15:0] data_in_port2;
    reg rst;
    reg write_en_port1;
    reg write_en_port2;
    wire [15:0] data_out_port1;
    wire [15:0] data_out_port2;
    wire error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_port1(addr_port1),
        .addr_port2(addr_port2),
        .clk(clk),
        .data_in_port1(data_in_port1),
        .data_in_port2(data_in_port2),
        .rst(rst),
        .write_en_port1(write_en_port1),
        .write_en_port2(write_en_port2),
        .data_out_port1(data_out_port1),
        .data_out_port2(data_out_port2),
        .error(error)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            addr_port1 = 0;
            addr_port2 = 0;
            data_in_port1 = 0;
            data_in_port2 = 0;
            write_en_port1 = 0;
            write_en_port2 = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase%03d: Basic Write and Read", test_num);
            reset_dut();


            addr_port1 = 16'h0001; data_in_port1 = 16'hAAAA; write_en_port1 = 1;
            addr_port2 = 16'h0002; data_in_port2 = 16'h5555; write_en_port2 = 1;
            repeat(4) @(posedge clk);


            write_en_port1 = 0; write_en_port2 = 0;
            addr_port1 = 16'h0001; addr_port2 = 16'h0002;
            repeat(4) @(posedge clk);

            #1;
            #1;

            check_outputs(16'hAAAA, 16'h5555, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase%03d: Higher Addresses and Data", test_num);
            reset_dut();

            addr_port1 = 16'h00FF; data_in_port1 = 16'h1234; write_en_port1 = 1;
            addr_port2 = 16'h0F00; data_in_port2 = 16'hC0DE; write_en_port2 = 1;
            repeat(4) @(posedge clk);

            write_en_port1 = 0; write_en_port2 = 0;
            addr_port1 = 16'h00FF; addr_port2 = 16'h0F00;
            repeat(4) @(posedge clk);

            #1;
            #1;

            check_outputs(16'h1234, 16'hC0DE, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase%03d: Overwriting memory", test_num);
            reset_dut();


            addr_port1 = 16'h0005; data_in_port1 = 16'h1111; write_en_port1 = 1;
            repeat(4) @(posedge clk);


            write_en_port1 = 0;
            addr_port2 = 16'h0005; data_in_port2 = 16'h2222; write_en_port2 = 1;
            repeat(4) @(posedge clk);


            write_en_port2 = 0;
            addr_port1 = 16'h0005; addr_port2 = 16'h0005;
            repeat(4) @(posedge clk);

            #1;
            #1;

            check_outputs(16'h2222, 16'h2222, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase%03d: Max Value and Parity check", test_num);
            reset_dut();

            addr_port1 = 16'hFFFF; data_in_port1 = 16'hFFFF; write_en_port1 = 1;
            addr_port2 = 16'h0000; data_in_port2 = 16'h0000; write_en_port2 = 1;
            repeat(4) @(posedge clk);

            write_en_port1 = 0; write_en_port2 = 0;
            addr_port1 = 16'hFFFF; addr_port2 = 16'h0000;
            repeat(4) @(posedge clk);

            #1;
            #1;

            check_outputs(16'hFFFF, 16'h0000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase%03d: Multi-cycle access sequence", test_num);
            reset_dut();


            addr_port1 = 16'h0010; data_in_port1 = 16'hCAFE; write_en_port1 = 1;
            addr_port2 = 16'h0011; data_in_port2 = 16'hBABE; write_en_port2 = 1;
            repeat(4) @(posedge clk);


            write_en_port1 = 0;
            addr_port1 = 16'h0010;
            addr_port2 = 16'h0012; data_in_port2 = 16'hDEAD; write_en_port2 = 1;
            repeat(4) @(posedge clk);


            write_en_port2 = 0;
            addr_port1 = 16'h0011;
            addr_port2 = 16'h0012;
            repeat(4) @(posedge clk);

            #1;
            #1;

            check_outputs(16'hBABE, 16'hDEAD, 1'b0);
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
        input [15:0] expected_data_out_port1;
        input [15:0] expected_data_out_port2;
        input expected_error;
        begin
            if (expected_data_out_port1 === (expected_data_out_port1 ^ data_out_port1 ^ expected_data_out_port1) &&
                expected_data_out_port2 === (expected_data_out_port2 ^ data_out_port2 ^ expected_data_out_port2) &&
                expected_error === (expected_error ^ error ^ expected_error)) begin
                $display("PASS");
                $display("  Outputs: data_out_port1=%h, data_out_port2=%h, error=%b",
                         data_out_port1, data_out_port2, error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out_port1=%h, data_out_port2=%h, error=%b",
                         expected_data_out_port1, expected_data_out_port2, expected_error);
                $display("  Got:      data_out_port1=%h, data_out_port2=%h, error=%b",
                         data_out_port1, data_out_port2, error);
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
        $dumpvars(0,addr_port1, addr_port2, clk, data_in_port1, data_in_port2, rst, write_en_port1, write_en_port2, data_out_port1, data_out_port2, error);
    end

endmodule
