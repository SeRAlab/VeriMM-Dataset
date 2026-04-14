`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dbA;
    reg [7:0] dbB;
    reg [7:0] dbC;
    reg [7:0] dbD;
    reg enable;
    reg enable_update;
    wire [1:0] A;
    wire clr_n;
    wire cs_n;
    wire [7:0] db;
    wire ldac_n;
    wire pd_n;
    wire wr_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dbA(dbA),
        .dbB(dbB),
        .dbC(dbC),
        .dbD(dbD),
        .enable(enable),
        .enable_update(enable_update),
        .A(A),
        .clr_n(clr_n),
        .cs_n(cs_n),
        .db(db),
        .ldac_n(ldac_n),
        .pd_n(pd_n),
        .wr_n(wr_n)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            enable_update = 0;
            dbA = 8'h00;
            dbB = 8'h00;
            dbC = 8'h00;
            dbD = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Standard Write Cycle...");
            reset_dut();
            dbA = 8'h11; dbB = 8'h22; dbC = 8'h33; dbD = 8'h44;
            enable = 1;
            enable_update = 1;


            repeat(25) @(posedge clk);



            #1;




            check_outputs(2'b11, 1'b1, 1'b1, 8'h44, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Disabled State Check...");
            reset_dut();
            dbA = 8'hFF;
            enable = 0;
            enable_update = 0;

            repeat(10) @(posedge clk);


            #1;



            check_outputs(A, 1'b1, 1'b1, db, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Write Cycle without LDAC Update...");
            reset_dut();
            dbA = 8'hAA; dbB = 8'hBB; dbC = 8'hCC; dbD = 8'hDD;
            enable = 1;
            enable_update = 0;

            repeat(25) @(posedge clk);


            #1;



            check_outputs(2'b11, 1'b1, 1'b1, 8'hDD, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Toggle Enable...");
            reset_dut();
            dbA = 8'h55;
            enable = 1;
            repeat(2) @(posedge clk);
            enable = 0;
            repeat(10) @(posedge clk);


            #1;



            check_outputs(A, 1'b1, 1'b1, db, 1'b1, 1'b1, 1'b1);
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
        input [1:0] expected_A;
        input expected_clr_n;
        input expected_cs_n;
        input [7:0] expected_db;
        input expected_ldac_n;
        input expected_pd_n;
        input expected_wr_n;
        begin
            if (expected_A === (expected_A ^ A ^ expected_A) &&
                expected_clr_n === (expected_clr_n ^ clr_n ^ expected_clr_n) &&
                expected_cs_n === (expected_cs_n ^ cs_n ^ expected_cs_n) &&
                expected_db === (expected_db ^ db ^ expected_db) &&
                expected_ldac_n === (expected_ldac_n ^ ldac_n ^ expected_ldac_n) &&
                expected_pd_n === (expected_pd_n ^ pd_n ^ expected_pd_n) &&
                expected_wr_n === (expected_wr_n ^ wr_n ^ expected_wr_n)) begin
                $display("PASS");
                $display("  Outputs: A=%h, clr_n=%b, cs_n=%b, db=%h, ldac_n=%b, pd_n=%b, wr_n=%b",
                         A, clr_n, cs_n, db, ldac_n, pd_n, wr_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A=%h, clr_n=%b, cs_n=%b, db=%h, ldac_n=%b, pd_n=%b, wr_n=%b",
                         expected_A, expected_clr_n, expected_cs_n, expected_db, expected_ldac_n, expected_pd_n, expected_wr_n);
                $display("  Got:      A=%h, clr_n=%b, cs_n=%b, db=%h, ldac_n=%b, pd_n=%b, wr_n=%b",
                         A, clr_n, cs_n, db, ldac_n, pd_n, wr_n);
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
        $dumpvars(0,clk, dbA, dbB, dbC, dbD, enable, enable_update, A, clr_n, cs_n, db, ldac_n, pd_n, wr_n);
    end

endmodule
