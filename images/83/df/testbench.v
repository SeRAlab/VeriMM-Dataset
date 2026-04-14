`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [12:0] mem_addr;
    reg [7:0] mem_din;
    reg mem_re;
    reg mem_we;
    reg rst;
    wire mem_a;
    wire [2:0] mem_ba;
    wire mem_cas_n;
    wire mem_ck;
    wire mem_ck_n;
    wire mem_cke;
    wire mem_cs_n;
    wire mem_dm;
    wire [7:0] mem_dout;
    wire mem_odt;
    wire mem_ras_n;
    wire mem_reset_n;
    wire mem_we_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mem_addr(mem_addr),
        .mem_din(mem_din),
        .mem_re(mem_re),
        .mem_we(mem_we),
        .rst(rst),
        .mem_a(mem_a),
        .mem_ba(mem_ba),
        .mem_cas_n(mem_cas_n),
        .mem_ck(mem_ck),
        .mem_ck_n(mem_ck_n),
        .mem_cke(mem_cke),
        .mem_cs_n(mem_cs_n),
        .mem_dm(mem_dm),
        .mem_dout(mem_dout),
        .mem_odt(mem_odt),
        .mem_ras_n(mem_ras_n),
        .mem_reset_n(mem_reset_n),
        .mem_we_n(mem_we_n)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            mem_addr = 0;
            mem_din = 0;
            mem_we = 0;
            mem_re = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Write Operation", test_num);
            reset_dut();

            mem_addr = 13'h0ABC;
            mem_din = 8'h5A;
            mem_we = 1;
            mem_re = 0;

            @(posedge clk);
            #2;



            #1;




            check_outputs(
                13'h0ABC,
                3'b000,
                1'b0,
                1'b1,
                1'b0,
                1'b1,
                1'b0,
                1'b0,
                8'h5A,
                1'b0,
                1'b0,
                1'b1,
                1'b0
            );
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Read Operation", test_num);
            reset_dut();

            mem_addr = 13'h1555;
            mem_we = 0;
            mem_re = 1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(
                13'h1555,
                3'b000,
                1'b0,
                1'b1,
                1'b0,
                1'b1,
                1'b0,
                1'b0,
                8'h00,
                1'b0,
                1'b0,
                1'b1,
                1'b1
            );
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Idle State", test_num);
            reset_dut();

            mem_addr = 13'h0000;
            mem_we = 0;
            mem_re = 0;

            @(posedge clk);
            #2;


            #1;



            check_outputs(
                13'h0000,
                3'b000,
                1'b1,
                1'b1,
                1'b0,
                1'b1,
                1'b1,
                1'b0,
                8'h00,
                1'b0,
                1'b1,
                1'b1,
                1'b1
            );
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Address Write", test_num);
            reset_dut();

            mem_addr = 13'h1FFF;
            mem_din = 8'hFF;
            mem_we = 1;
            mem_re = 0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(
                13'h1FFF,
                3'b000,
                1'b0,
                1'b1,
                1'b0,
                1'b1,
                1'b0,
                1'b0,
                8'hFF,
                1'b0,
                1'b0,
                1'b1,
                1'b0
            );
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
        input expected_mem_a;
        input [2:0] expected_mem_ba;
        input expected_mem_cas_n;
        input expected_mem_ck;
        input expected_mem_ck_n;
        input expected_mem_cke;
        input expected_mem_cs_n;
        input expected_mem_dm;
        input [7:0] expected_mem_dout;
        input expected_mem_odt;
        input expected_mem_ras_n;
        input expected_mem_reset_n;
        input expected_mem_we_n;
        begin
            if (expected_mem_a === (expected_mem_a ^ mem_a ^ expected_mem_a) &&
                expected_mem_ba === (expected_mem_ba ^ mem_ba ^ expected_mem_ba) &&
                expected_mem_cas_n === (expected_mem_cas_n ^ mem_cas_n ^ expected_mem_cas_n) &&
                expected_mem_ck === (expected_mem_ck ^ mem_ck ^ expected_mem_ck) &&
                expected_mem_ck_n === (expected_mem_ck_n ^ mem_ck_n ^ expected_mem_ck_n) &&
                expected_mem_cke === (expected_mem_cke ^ mem_cke ^ expected_mem_cke) &&
                expected_mem_cs_n === (expected_mem_cs_n ^ mem_cs_n ^ expected_mem_cs_n) &&
                expected_mem_dm === (expected_mem_dm ^ mem_dm ^ expected_mem_dm) &&
                expected_mem_dout === (expected_mem_dout ^ mem_dout ^ expected_mem_dout) &&
                expected_mem_odt === (expected_mem_odt ^ mem_odt ^ expected_mem_odt) &&
                expected_mem_ras_n === (expected_mem_ras_n ^ mem_ras_n ^ expected_mem_ras_n) &&
                expected_mem_reset_n === (expected_mem_reset_n ^ mem_reset_n ^ expected_mem_reset_n) &&
                expected_mem_we_n === (expected_mem_we_n ^ mem_we_n ^ expected_mem_we_n)) begin
                $display("PASS");
                $display("  Outputs: mem_a=%b, mem_ba=%h, mem_cas_n=%b, mem_ck=%b, mem_ck_n=%b, mem_cke=%b, mem_cs_n=%b, mem_dm=%b, mem_dout=%h, mem_odt=%b, mem_ras_n=%b, mem_reset_n=%b, mem_we_n=%b",
                         mem_a, mem_ba, mem_cas_n, mem_ck, mem_ck_n, mem_cke, mem_cs_n, mem_dm, mem_dout, mem_odt, mem_ras_n, mem_reset_n, mem_we_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mem_a=%b, mem_ba=%h, mem_cas_n=%b, mem_ck=%b, mem_ck_n=%b, mem_cke=%b, mem_cs_n=%b, mem_dm=%b, mem_dout=%h, mem_odt=%b, mem_ras_n=%b, mem_reset_n=%b, mem_we_n=%b",
                         expected_mem_a, expected_mem_ba, expected_mem_cas_n, expected_mem_ck, expected_mem_ck_n, expected_mem_cke, expected_mem_cs_n, expected_mem_dm, expected_mem_dout, expected_mem_odt, expected_mem_ras_n, expected_mem_reset_n, expected_mem_we_n);
                $display("  Got:      mem_a=%b, mem_ba=%h, mem_cas_n=%b, mem_ck=%b, mem_ck_n=%b, mem_cke=%b, mem_cs_n=%b, mem_dm=%b, mem_dout=%h, mem_odt=%b, mem_ras_n=%b, mem_reset_n=%b, mem_we_n=%b",
                         mem_a, mem_ba, mem_cas_n, mem_ck, mem_ck_n, mem_cke, mem_cs_n, mem_dm, mem_dout, mem_odt, mem_ras_n, mem_reset_n, mem_we_n);
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
        $dumpvars(0,clk, mem_addr, mem_din, mem_re, mem_we, rst, mem_a, mem_ba, mem_cas_n, mem_ck, mem_ck_n, mem_cke, mem_cs_n, mem_dm, mem_dout, mem_odt, mem_ras_n, mem_reset_n, mem_we_n);
    end

endmodule
