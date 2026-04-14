`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Sclk;
    reg [15:0] data_in;
    reg rd_en;
    reg [3:0] rj_rd_addr;
    reg [3:0] rj_wr_addr;
    reg wr_en;
    wire [15:0] rj_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Sclk(Sclk),
        .data_in(data_in),
        .rd_en(rd_en),
        .rj_rd_addr(rj_rd_addr),
        .rj_wr_addr(rj_wr_addr),
        .wr_en(wr_en),
        .rj_data(rj_data)
    );

    // Clock generation (10ns period)
    initial begin
        Sclk = 0;
        forever #5 Sclk = ~Sclk;
    end

        task reset_dut;

        begin
            wr_en = 0;
            rd_en = 0;
            rj_wr_addr = 0;
            rj_rd_addr = 0;
            data_in = 0;
            @(posedge Sclk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Write and Read", test_num);
            reset_dut();


            wr_en = 1;
            rj_wr_addr = 4'h0;
            data_in = 16'hAAAA;
            @(negedge Sclk);


            wr_en = 0;
            rd_en = 1;
            rj_rd_addr = 4'h0;
            #2;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Read Enable Gate Logic", test_num);
            reset_dut();


            wr_en = 1;
            rj_wr_addr = 4'h5;
            data_in = 16'h5555;
            @(negedge Sclk);


            wr_en = 0;
            rd_en = 0;
            rj_rd_addr = 4'h5;
            #2;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Address Isolation", test_num);
            reset_dut();


            wr_en = 1;
            rj_wr_addr = 4'h1;
            data_in = 16'h1111;
            @(negedge Sclk);


            rj_wr_addr = 4'h2;
            data_in = 16'h2222;
            @(negedge Sclk);


            wr_en = 0;
            rd_en = 1;
            rj_rd_addr = 4'h1;
            #2;
            #1;

            check_outputs(16'h1111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Overwrite Operation", test_num);
            reset_dut();


            wr_en = 1;
            rj_wr_addr = 4'hA;
            data_in = 16'hBEEF;
            @(negedge Sclk);


            data_in = 16'hDEAD;
            @(negedge Sclk);

            wr_en = 0;
            rd_en = 1;
            rj_rd_addr = 4'hA;
            #2;
            #1;

            check_outputs(16'hDEAD);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Write Enable Gate Logic", test_num);
            reset_dut();


            wr_en = 1;
            rj_wr_addr = 4'h8;
            data_in = 16'h7777;
            @(negedge Sclk);


            wr_en = 0;
            data_in = 16'h8888;
            @(negedge Sclk);


            rd_en = 1;
            rj_rd_addr = 4'h8;
            #2;
            #1;

            check_outputs(16'h7777);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Boundary Address 15", test_num);
            reset_dut();

            wr_en = 1;
            rj_wr_addr = 4'hF;
            data_in = 16'hFFFF;
            @(negedge Sclk);

            wr_en = 0;
            rd_en = 1;
            rj_rd_addr = 4'hF;
            #2;
            #1;

            check_outputs(16'hFFFF);
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
        input [15:0] expected_rj_data;
        begin
            if (expected_rj_data === (expected_rj_data ^ rj_data ^ expected_rj_data)) begin
                $display("PASS");
                $display("  Outputs: rj_data=%h",
                         rj_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rj_data=%h",
                         expected_rj_data);
                $display("  Got:      rj_data=%h",
                         rj_data);
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
        $dumpvars(0,Sclk, data_in, rd_en, rj_rd_addr, rj_wr_addr, wr_en, rj_data);
    end

endmodule
