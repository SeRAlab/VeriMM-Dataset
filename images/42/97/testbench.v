`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] crac_out;
    reg crac_we;
    reg [19:0] in_slt2;
    reg rst;
    reg valid;
    wire [15:0] crac_din;
    wire crac_rd_done;
    wire crac_valid;
    wire crac_wr;
    wire crac_wr_done;
    wire [19:0] out_slt1;
    wire [19:0] out_slt2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .crac_out(crac_out),
        .crac_we(crac_we),
        .in_slt2(in_slt2),
        .rst(rst),
        .valid(valid),
        .crac_din(crac_din),
        .crac_rd_done(crac_rd_done),
        .crac_valid(crac_valid),
        .crac_wr(crac_wr),
        .crac_wr_done(crac_wr_done),
        .out_slt1(out_slt1),
        .out_slt2(out_slt2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            crac_we = 0;
            crac_out = 0;
            in_slt2 = 0;
            valid = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            @(posedge clk);
            crac_we = 1;
            crac_out = 32'h00021234;
            valid = 1;
            @(posedge clk);
            valid = 0;


            #1;



            check_outputs(16'h0, 0, 1, 1, 1, 20'h81000, 20'h12340);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge clk);
            crac_we = 0;
            crac_out = 32'h00040000;
            in_slt2 = 20'hABCD0;
            valid = 1;
            @(posedge clk);
            valid = 0;


            #1;



            check_outputs(16'hABCD, 1, 1, 0, 0, 20'hC2000, 20'h00000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(posedge clk);
            crac_we = 1;
            crac_out = 32'h007EFFFF;
            valid = 1;
            @(posedge clk);
            valid = 0;


            #1;



            check_outputs(16'h0, 0, 1, 1, 1, 20'hBF000, 20'hFFFF0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            @(posedge clk);
            crac_we = 0;
            crac_out = 32'h00000000;
            in_slt2 = 20'h55AA0;
            valid = 1;
            @(posedge clk);
            valid = 0;

            #1;


            check_outputs(16'h55AA, 1, 1, 0, 0, 20'hC0000, 20'h00000);
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
        input [15:0] expected_crac_din;
        input expected_crac_rd_done;
        input expected_crac_valid;
        input expected_crac_wr;
        input expected_crac_wr_done;
        input [19:0] expected_out_slt1;
        input [19:0] expected_out_slt2;
        begin
            if (expected_crac_din === (expected_crac_din ^ crac_din ^ expected_crac_din) &&
                expected_crac_rd_done === (expected_crac_rd_done ^ crac_rd_done ^ expected_crac_rd_done) &&
                expected_crac_valid === (expected_crac_valid ^ crac_valid ^ expected_crac_valid) &&
                expected_crac_wr === (expected_crac_wr ^ crac_wr ^ expected_crac_wr) &&
                expected_crac_wr_done === (expected_crac_wr_done ^ crac_wr_done ^ expected_crac_wr_done) &&
                expected_out_slt1 === (expected_out_slt1 ^ out_slt1 ^ expected_out_slt1) &&
                expected_out_slt2 === (expected_out_slt2 ^ out_slt2 ^ expected_out_slt2)) begin
                $display("PASS");
                $display("  Outputs: crac_din=%h, crac_rd_done=%b, crac_valid=%b, crac_wr=%b, crac_wr_done=%b, out_slt1=%h, out_slt2=%h",
                         crac_din, crac_rd_done, crac_valid, crac_wr, crac_wr_done, out_slt1, out_slt2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crac_din=%h, crac_rd_done=%b, crac_valid=%b, crac_wr=%b, crac_wr_done=%b, out_slt1=%h, out_slt2=%h",
                         expected_crac_din, expected_crac_rd_done, expected_crac_valid, expected_crac_wr, expected_crac_wr_done, expected_out_slt1, expected_out_slt2);
                $display("  Got:      crac_din=%h, crac_rd_done=%b, crac_valid=%b, crac_wr=%b, crac_wr_done=%b, out_slt1=%h, out_slt2=%h",
                         crac_din, crac_rd_done, crac_valid, crac_wr, crac_wr_done, out_slt1, out_slt2);
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
        $dumpvars(0,clk, crac_out, crac_we, in_slt2, rst, valid, crac_din, crac_rd_done, crac_valid, crac_wr, crac_wr_done, out_slt1, out_slt2);
    end

endmodule
