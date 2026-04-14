`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [8:0] r_addr;
    reg [8:0] w_addr;
    reg [63:0] w_data;
    reg w_valid;
    wire [63:0] r_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .r_addr(r_addr),
        .w_addr(w_addr),
        .w_data(w_data),
        .w_valid(w_valid),
        .r_data(r_data)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            w_valid = 0;
            w_addr = 0;
            w_data = 0;
            r_addr = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase 001: Basic Write and Read at Address 100");


            @(negedge clock);
            w_addr = 9'd100;
            w_data = 64'hFEDCBA9876543210;
            w_valid = 1;
            @(negedge clock);
            w_valid = 0;


            r_addr = 9'd100;


            repeat(2) @(posedge clock);
            #1;
            #1;

            check_outputs(64'hFEDCBA9876543210);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase 002: Write and Read at Boundary Address 0");

            @(negedge clock);
            w_addr = 9'd0;
            w_data = 64'hAAAA_BBBB_CCCC_DDDD;
            w_valid = 1;
            @(negedge clock);
            w_valid = 0;

            r_addr = 9'd0;
            repeat(2) @(posedge clock);
            #1;
            #1;

            check_outputs(64'hAAAA_BBBB_CCCC_DDDD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase 003: Write and Read at Boundary Address 511");

            @(negedge clock);
            w_addr = 9'd511;
            w_data = 64'h1111_2222_3333_4444;
            w_valid = 1;
            @(negedge clock);
            w_valid = 0;

            r_addr = 9'd511;
            repeat(2) @(posedge clock);
            #1;
            #1;

            check_outputs(64'h1111_2222_3333_4444);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase 004: Verify w_valid prevents writing when low");


            @(negedge clock);
            w_addr = 9'd50;
            w_data = 64'h5555_5555_5555_5555;
            w_valid = 1;
            @(negedge clock);


            w_data = 64'hFFFF_FFFF_FFFF_FFFF;
            w_valid = 0;
            @(negedge clock);


            r_addr = 9'd50;
            repeat(2) @(posedge clock);
            #1;
            #1;

            check_outputs(64'h5555_5555_5555_5555);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase 005: Simultaneous Read and Write at different addresses");


            @(negedge clock);
            w_addr = 9'd10;
            w_data = 64'hDEAD_BEEF_DEAD_BEEF;
            w_valid = 1;
            @(negedge clock);
            w_valid = 0;


            @(negedge clock);
            w_addr = 9'd20;
            w_data = 64'hCAFE_BABE_CAFE_BABE;
            w_valid = 1;
            r_addr = 9'd10;


            repeat(2) @(posedge clock);
            #1;
            #1;

            check_outputs(64'hDEAD_BEEF_DEAD_BEEF);
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
        input [63:0] expected_r_data;
        begin
            if (expected_r_data === (expected_r_data ^ r_data ^ expected_r_data)) begin
                $display("PASS");
                $display("  Outputs: r_data=%h",
                         r_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r_data=%h",
                         expected_r_data);
                $display("  Got:      r_data=%h",
                         r_data);
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
        $dumpvars(0,clock, r_addr, w_addr, w_data, w_valid, r_data);
    end

endmodule
