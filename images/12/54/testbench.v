`timescale 1ns/1ps

module CRC_Generator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [3:0] polynomial;
    reg rst;
    reg valid;
    wire [3:0] crc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    CRC_Generator dut (
        .clk(clk),
        .data_in(data_in),
        .polynomial(polynomial),
        .rst(rst),
        .valid(valid),
        .crc_out(crc_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        valid = 0;
        data_in = 8'h00;
        polynomial = 4'h0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Data=0x00, Poly=0x3 (x^4+x+1)", test_num);
        reset_dut();
        data_in = 8'h00;
        polynomial = 4'h3;
        valid = 1;
        @(posedge clk);
        valid = 0;

        repeat(8) @(posedge clk);
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Data=0xFF, Poly=0x3", test_num);
        reset_dut();
        data_in = 8'hFF;
        polynomial = 4'h3;
        valid = 1;
        @(posedge clk);
        valid = 0;
        repeat(8) @(posedge clk);
        #1;

        check_outputs(4'h8);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Data=0xA5, Poly=0x3", test_num);
        reset_dut();
        data_in = 8'hA5;
        polynomial = 4'h3;
        valid = 1;
        @(posedge clk);
        valid = 0;
        repeat(8) @(posedge clk);
        #1;

        check_outputs(4'h4);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Data=0x55, Poly=0x3", test_num);
        reset_dut();
        data_in = 8'h55;
        polynomial = 4'h3;
        valid = 1;
        @(posedge clk);
        valid = 0;
        repeat(8) @(posedge clk);
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Data=0xA5, Poly=0x9", test_num);
        reset_dut();
        data_in = 8'hA5;
        polynomial = 4'h9;
        valid = 1;
        @(posedge clk);
        valid = 0;
        repeat(8) @(posedge clk);
        #1;

        check_outputs(4'h7);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %03d: Reset mid-operation", test_num);
        reset_dut();
        data_in = 8'hFF;
        polynomial = 4'h3;
        valid = 1;
        @(posedge clk);
        valid = 0;
        repeat(2) @(posedge clk);
        rst = 1;
        @(posedge clk);
        rst = 0;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(4'h0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("CRC_Generator Testbench");
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
        input [3:0] expected_crc_out;
        begin
            if (expected_crc_out === (expected_crc_out ^ crc_out ^ expected_crc_out)) begin
                $display("PASS");
                $display("  Outputs: crc_out=%h",
                         crc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc_out=%h",
                         expected_crc_out);
                $display("  Got:      crc_out=%h",
                         crc_out);
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
        $dumpvars(0,clk, data_in, polynomial, rst, valid, crc_out);
    end

endmodule
