`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg adc_clk;
    reg [15:0] adc_data_in;
    reg [15:0] adc_data_pn;
    reg adc_valid_in;
    wire adc_pn_err;
    wire adc_pn_oos;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adc_clk(adc_clk),
        .adc_data_in(adc_data_in),
        .adc_data_pn(adc_data_pn),
        .adc_valid_in(adc_valid_in),
        .adc_pn_err(adc_pn_err),
        .adc_pn_oos(adc_pn_oos)
    );

    // Clock generation (10ns period)
    initial begin
        adc_clk = 0;
        forever #5 adc_clk = ~adc_clk;
    end

        task reset_dut;

    begin
        adc_valid_in <= 1'b0;
        adc_data_in <= 16'h0;
        adc_data_pn <= 16'h0;
        repeat(5) @(posedge adc_clk);
    end
        endtask
    task testcase001;

    begin
        $display("Running Testcase 001: Normal operation with matching data...");
        test_num = 1;
        reset_dut();


        adc_valid_in <= 1'b1;
        adc_data_in <= 16'hA5A5;
        adc_data_pn <= 16'hA5A5;


        repeat(32) @(posedge adc_clk);


        #1;



        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Running Testcase 002: Error detection on data mismatch...");
        test_num = 2;
        reset_dut();


        adc_valid_in <= 1'b1;
        adc_data_in <= 16'h1111;
        adc_data_pn <= 16'h1111;
        repeat(20) @(posedge adc_clk);


        adc_data_in <= 16'hFFFF;
        adc_data_pn <= 16'h1111;
        @(posedge adc_clk);



        #1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        $display("Running Testcase 003: Data integrity check ignores zero data...");
        test_num = 3;
        reset_dut();

        adc_valid_in <= 1'b1;
        adc_data_in <= 16'h0000;
        adc_data_pn <= 16'hBEEF;

        repeat(5) @(posedge adc_clk);


        #1;



        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Running Testcase 004: Valid signal gating check...");
        test_num = 4;
        reset_dut();

        adc_valid_in <= 1'b0;
        adc_data_in <= 16'h1234;
        adc_data_pn <= 16'h5678;

        repeat(5) @(posedge adc_clk);


        #1;



        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("Running Testcase 005: Out-of-Sync detection...");
        test_num = 5;
        reset_dut();


        adc_valid_in <= 1'b1;
        adc_data_in <= 16'hAAAA;
        adc_data_pn <= 16'h5555;


        repeat(128) @(posedge adc_clk);


        #1;



        check_outputs(1'b1, 1'b1);
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
        input expected_adc_pn_err;
        input expected_adc_pn_oos;
        begin
            if (expected_adc_pn_err === (expected_adc_pn_err ^ adc_pn_err ^ expected_adc_pn_err) &&
                expected_adc_pn_oos === (expected_adc_pn_oos ^ adc_pn_oos ^ expected_adc_pn_oos)) begin
                $display("PASS");
                $display("  Outputs: adc_pn_err=%b, adc_pn_oos=%b",
                         adc_pn_err, adc_pn_oos);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adc_pn_err=%b, adc_pn_oos=%b",
                         expected_adc_pn_err, expected_adc_pn_oos);
                $display("  Got:      adc_pn_err=%b, adc_pn_oos=%b",
                         adc_pn_err, adc_pn_oos);
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
        $dumpvars(0,adc_clk, adc_data_in, adc_data_pn, adc_valid_in, adc_pn_err, adc_pn_oos);
    end

endmodule
