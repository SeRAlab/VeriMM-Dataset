`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [3:0] rd_addr;
    reg [15:0] wr_data;
    reg wr_en;
    wire [15:0] rd_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .rd_addr(rd_addr),
        .wr_data(wr_data),
        .wr_en(wr_en),
        .rd_data(rd_data)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            @(posedge clock);
            wr_en = 0;
            rd_addr = 0;
            wr_data = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %03d: Basic Write and Read", test_num);


            @(negedge clock);
            wr_en = 1;
            rd_addr = 4'h5;
            wr_data = 16'hABCD;

            @(negedge clock);
            wr_en = 0;


            @(posedge clock);
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %03d: Overwriting Value", test_num);


            @(negedge clock);
            wr_en = 1; rd_addr = 4'hA; wr_data = 16'h1111;
            @(negedge clock);

            wr_en = 1; rd_addr = 4'hA; wr_data = 16'h2222;
            @(negedge clock);
            wr_en = 0;

            @(posedge clock);
            #1;
            #1;

            check_outputs(16'h2222);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %03d: Write Enable Verification", test_num);


            @(negedge clock);
            wr_en = 1; rd_addr = 4'h7; wr_data = 16'h5555;
            @(negedge clock);


            wr_en = 0; rd_addr = 4'h7; wr_data = 16'hFFFF;
            @(negedge clock);


            rd_addr = 4'h7;
            @(posedge clock);
            #1;

            #1;


            check_outputs(16'h5555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %03d: Boundary Address Check (Addr 0 and 15)", test_num);


            @(negedge clock);
            wr_en = 1; rd_addr = 4'h0; wr_data = 16'hAAAA;
            @(negedge clock);

            wr_en = 1; rd_addr = 4'hF; wr_data = 16'hFFFF;
            @(negedge clock);
            wr_en = 0;


            rd_addr = 4'hF;
            @(posedge clock);
            #1;
            #1;

            check_outputs(16'hFFFF);


            rd_addr = 4'h0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(16'hAAAA);
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
        input [15:0] expected_rd_data;
        begin
            if (expected_rd_data === (expected_rd_data ^ rd_data ^ expected_rd_data)) begin
                $display("PASS");
                $display("  Outputs: rd_data=%h",
                         rd_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd_data=%h",
                         expected_rd_data);
                $display("  Got:      rd_data=%h",
                         rd_data);
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
        $dumpvars(0,clock, rd_addr, wr_data, wr_en, rd_data);
    end

endmodule
