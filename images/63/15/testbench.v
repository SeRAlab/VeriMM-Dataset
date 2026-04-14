`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] mv_i;
    reg rst_n;
    reg valid_i;
    wire [5:0] mv_addr_o;
    wire [7:0] mv_o;
    wire valid_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mv_i(mv_i),
        .rst_n(rst_n),
        .valid_i(valid_i),
        .mv_addr_o(mv_addr_o),
        .mv_o(mv_o),
        .valid_o(valid_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            valid_i = 0;
            mv_i = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            valid_i = 1;
            mv_i = 64'hFEDCBA9876543211;
            @(posedge clk);
            valid_i = 0;

            #1;


            check_outputs(6'd0, 8'h11, 1'b1);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                valid_i = 1;
                mv_i = 64'h0 + i + 8'h22;
                @(posedge clk);
            end
            valid_i = 0;


            #1;



            check_outputs(6'd7, 8'h29, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            reset_dut();
            for (i = 0; i < 9; i = i + 1) begin
                valid_i = 1;
                mv_i = 64'hA0 + i;
                @(posedge clk);
            end
            valid_i = 0;


            #1;



            check_outputs(6'd8, 8'hA8, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();
            for (i = 0; i < 48; i = i + 1) begin
                valid_i = 1;
                mv_i = 64'hB0 + i;
                @(posedge clk);
            end
            valid_i = 0;


            #1;



            check_outputs(6'd47, 8'hDF, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            reset_dut();
            for (i = 0; i < 49; i = i + 1) begin
                valid_i = 1;
                mv_i = 64'hC0 + i;
                @(posedge clk);
            end
            valid_i = 0;


            #1;



            check_outputs(6'd0, 8'hF0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            valid_i = 1;
            mv_i = 64'h1234;
            @(posedge clk);
            valid_i = 0;
            @(posedge clk);
            @(posedge clk);


            #1;



            check_outputs(6'd0, 8'h34, 1'b0);
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
        input [5:0] expected_mv_addr_o;
        input [7:0] expected_mv_o;
        input expected_valid_o;
        begin
            if (expected_mv_addr_o === (expected_mv_addr_o ^ mv_addr_o ^ expected_mv_addr_o) &&
                expected_mv_o === (expected_mv_o ^ mv_o ^ expected_mv_o) &&
                expected_valid_o === (expected_valid_o ^ valid_o ^ expected_valid_o)) begin
                $display("PASS");
                $display("  Outputs: mv_addr_o=%h, mv_o=%h, valid_o=%b",
                         mv_addr_o, mv_o, valid_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mv_addr_o=%h, mv_o=%h, valid_o=%b",
                         expected_mv_addr_o, expected_mv_o, expected_valid_o);
                $display("  Got:      mv_addr_o=%h, mv_o=%h, valid_o=%b",
                         mv_addr_o, mv_o, valid_o);
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
        $dumpvars(0,clk, mv_i, rst_n, valid_i, mv_addr_o, mv_o, valid_o);
    end

endmodule
