`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg resetn;
    reg s_cs;
    reg s_sclk;
    reg s_sdo;
    reg s_sdo_t;
    reg spi_active;
    wire data_ready;
    wire s_sdi;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .resetn(resetn),
        .s_cs(s_cs),
        .s_sclk(s_sclk),
        .s_sdo(s_sdo),
        .s_sdo_t(s_sdo_t),
        .spi_active(spi_active),
        .data_ready(data_ready),
        .s_sdi(s_sdi)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        resetn = 0;
        s_cs = 1;
        s_sclk = 0;
        s_sdo = 0;
        s_sdo_t = 0;
        spi_active = 0;
        #20;
        resetn = 1;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Post-reset state check", test_num);
        reset_dut();

        #1;


        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Successful timeout with low bit received", test_num);
        reset_dut();


        s_sdo = 0;
        s_cs = 0;
        spi_active = 1;
        #50;


        s_cs = 1;
        spi_active = 0;


        repeat(200) @(posedge clk);

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Timeout reset by spi_active", test_num);
        reset_dut();

        s_cs = 1;
        spi_active = 0;


        repeat(50) @(posedge clk);
        spi_active = 1;
        #20;
        spi_active = 0;


        repeat(100) @(posedge clk);


        #1;



        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Timeout reset by s_cs", test_num);
        reset_dut();

        s_cs = 1;
        spi_active = 0;

        repeat(50) @(posedge clk);
        s_cs = 0;
        #20;
        s_cs = 1;

        repeat(100) @(posedge clk);

        #1;


        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Timeout with high bit (no data_ready)", test_num);
        reset_dut();


        s_sdo = 1;
        s_cs = 0;
        spi_active = 1;
        #50;


        s_cs = 1;
        spi_active = 0;

        repeat(200) @(posedge clk);


        #1;



        check_outputs(1'b0, 1'b1);
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
        input expected_data_ready;
        input expected_s_sdi;
        begin
            if (expected_data_ready === (expected_data_ready ^ data_ready ^ expected_data_ready) &&
                expected_s_sdi === (expected_s_sdi ^ s_sdi ^ expected_s_sdi)) begin
                $display("PASS");
                $display("  Outputs: data_ready=%b, s_sdi=%b",
                         data_ready, s_sdi);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_ready=%b, s_sdi=%b",
                         expected_data_ready, expected_s_sdi);
                $display("  Got:      data_ready=%b, s_sdi=%b",
                         data_ready, s_sdi);
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
        $dumpvars(0,clk, resetn, s_cs, s_sclk, s_sdo, s_sdo_t, spi_active, data_ready, s_sdi);
    end

endmodule
