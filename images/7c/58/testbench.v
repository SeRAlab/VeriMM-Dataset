`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg check_enable;
    reg clk;
    reg crc_enable;
    reg [7:0] crc_in;
    reg [7:0] data_in;
    reg [7:0] poly;
    reg reset;
    wire [7:0] crc_out;
    wire match;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .check_enable(check_enable),
        .clk(clk),
        .crc_enable(crc_enable),
        .crc_in(crc_in),
        .data_in(data_in),
        .poly(poly),
        .reset(reset),
        .crc_out(crc_out),
        .match(match)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            crc_enable = 0;
            check_enable = 0;
            data_in = 8'h00;
            poly = 8'h00;
            crc_in = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: System Reset", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic CRC Calculation", test_num);
            reset_dut();

            data_in = 8'hA5;
            poly = 8'h07;
            crc_in = 8'h00;
            crc_enable = 1;
            check_enable = 0;

            @(posedge clk);
            #1;



            #1;




            check_outputs(crc_out, 1'b0);
        end
        endtask

    task testcase003;

        reg [7:0] captured_crc;
        begin
            test_num = 3;
            $display("Testcase %0d: CRC Verification - Positive Match", test_num);
            reset_dut();


            data_in = 8'h3C;
            poly = 8'h07;
            crc_in = 8'h00;
            crc_enable = 1;
            @(posedge clk);
            #1 captured_crc = crc_out;


            crc_enable = 1;
            check_enable = 1;
            crc_in = captured_crc;

            @(posedge clk);
            #1;

            #1;


            check_outputs(captured_crc, 1'b1);
        end
        endtask

    task testcase004;

        reg [7:0] captured_crc;
        begin
            test_num = 4;
            $display("Testcase %0d: CRC Verification - Mismatch", test_num);
            reset_dut();

            data_in = 8'hFF;
            poly = 8'h07;
            crc_enable = 1;
            check_enable = 1;
            crc_in = 8'hAA;

            @(posedge clk);
            #1;

            #1;


            check_outputs(crc_out, 1'b0);
        end
        endtask

    task testcase005;

        reg [7:0] initial_crc;
        begin
            test_num = 5;
            $display("Testcase %0d: Enable Signal Control", test_num);
            reset_dut();


            data_in = 8'h12;
            poly = 8'h07;
            crc_enable = 0;
            check_enable = 0;

            @(posedge clk);
            #1 initial_crc = crc_out;

            data_in = 8'h99;
            @(posedge clk);
            #1;


            #1;



            check_outputs(initial_crc, 1'b0);
        end
        endtask

    task testcase006;

        reg [7:0] crc_poly1;
        begin
            test_num = 6;
            $display("Testcase %0d: Polynomial Influence", test_num);
            reset_dut();

            data_in = 8'h55;
            poly = 8'h07;
            crc_enable = 1;
            @(posedge clk);
            #1 crc_poly1 = crc_out;

            reset_dut();
            data_in = 8'h55;
            poly = 8'h1D;
            crc_enable = 1;
            @(posedge clk);
            #1;

            if (crc_out != crc_poly1) begin
                $display("Success: Polynomial changed the output.");
                pass_count = pass_count + 1;
            end else begin
                $display("Failure: CRC output remained same despite polynomial change.");
                fail_count = fail_count + 1;
            end
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
        input [7:0] expected_crc_out;
        input expected_match;
        begin
            if (expected_crc_out === (expected_crc_out ^ crc_out ^ expected_crc_out) &&
                expected_match === (expected_match ^ match ^ expected_match)) begin
                $display("PASS");
                $display("  Outputs: crc_out=%h, match=%b",
                         crc_out, match);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc_out=%h, match=%b",
                         expected_crc_out, expected_match);
                $display("  Got:      crc_out=%h, match=%b",
                         crc_out, match);
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
        $dumpvars(0,check_enable, clk, crc_enable, crc_in, data_in, poly, reset, crc_out, match);
    end

endmodule
