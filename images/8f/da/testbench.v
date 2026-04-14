`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [3:0] rd_addr1;
    reg [3:0] rd_addr2;
    reg [3:0] wr_addr;
    reg [15:0] wr_data;
    reg write;
    wire [15:0] rd_data1;
    wire [15:0] rd_data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .rd_addr1(rd_addr1),
        .rd_addr2(rd_addr2),
        .wr_addr(wr_addr),
        .wr_data(wr_data),
        .write(write),
        .rd_data1(rd_data1),
        .rd_data2(rd_data2)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            write = 0;
            wr_addr = 0;
            wr_data = 0;
            rd_addr1 = 0;
            rd_addr2 = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Write and Read", test_num);
            reset_dut();


            @(negedge clock);
            write = 1;
            wr_addr = 4'h5;
            wr_data = 16'hAAAA;


            @(negedge clock);
            write = 0;
            rd_addr1 = 4'h5;
            rd_addr2 = 4'h0;


            @(posedge clock);
            #1;
            #1;

            check_outputs(16'hAAAA, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Dual Port Read", test_num);
            reset_dut();


            @(negedge clock);
            write = 1; wr_addr = 4'h2; wr_data = 16'hBBBB;

            @(negedge clock);
            write = 1; wr_addr = 4'h3; wr_data = 16'hCCCC;


            @(negedge clock);
            write = 0;
            rd_addr1 = 4'h2;
            rd_addr2 = 4'h3;

            @(posedge clock);
            #1;
            #1;

            check_outputs(16'hBBBB, 16'hCCCC);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simultaneous Read and Write", test_num);
            reset_dut();


            @(negedge clock);
            write = 1; wr_addr = 4'h2; wr_data = 16'h2222;


            @(negedge clock);
            write = 1;
            wr_addr = 4'hE;
            wr_data = 16'hEEEE;
            rd_addr1 = 4'h2;
            rd_addr2 = 4'hE;

            @(posedge clock);
            #1;



            @(negedge clock);
            write = 0;
            rd_addr1 = 4'h2;
            rd_addr2 = 4'hE;
            @(posedge clock);
            #1;
            #1;

            check_outputs(16'h2222, 16'hEEEE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overwriting Data", test_num);
            reset_dut();

            @(negedge clock);
            write = 1; wr_addr = 4'h7; wr_data = 16'h1111;
            @(negedge clock);
            write = 1; wr_addr = 4'h7; wr_data = 16'hFFFF;

            @(negedge clock);
            write = 0;
            rd_addr1 = 4'h7;
            rd_addr2 = 4'h7;

            @(posedge clock);
            #1;
            #1;

            check_outputs(16'hFFFF, 16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write Enable Check", test_num);
            reset_dut();


            @(negedge clock);
            write = 1; wr_addr = 4'hA; wr_data = 16'h5555;


            @(negedge clock);
            write = 0; wr_addr = 4'hA; wr_data = 16'h9999;


            @(negedge clock);
            rd_addr1 = 4'hA;

            @(posedge clock);
            #1;
            #1;

            check_outputs(16'h5555, 16'h0000);
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
        input [15:0] expected_rd_data1;
        input [15:0] expected_rd_data2;
        begin
            if (expected_rd_data1 === (expected_rd_data1 ^ rd_data1 ^ expected_rd_data1) &&
                expected_rd_data2 === (expected_rd_data2 ^ rd_data2 ^ expected_rd_data2)) begin
                $display("PASS");
                $display("  Outputs: rd_data1=%h, rd_data2=%h",
                         rd_data1, rd_data2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd_data1=%h, rd_data2=%h",
                         expected_rd_data1, expected_rd_data2);
                $display("  Got:      rd_data1=%h, rd_data2=%h",
                         rd_data1, rd_data2);
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
        $dumpvars(0,clock, rd_addr1, rd_addr2, wr_addr, wr_data, write, rd_data1, rd_data2);
    end

endmodule
