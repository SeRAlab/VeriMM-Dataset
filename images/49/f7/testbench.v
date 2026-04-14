`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] i_wbs_adr;
    reg i_wbs_cyc;
    reg [31:0] i_wbs_dat;
    reg i_wbs_stb;
    reg i_wbs_we;
    reg rst;
    wire o_wbs_ack;
    wire [31:0] o_wbs_dat;
    wire o_wbs_int;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .i_wbs_adr(i_wbs_adr),
        .i_wbs_cyc(i_wbs_cyc),
        .i_wbs_dat(i_wbs_dat),
        .i_wbs_stb(i_wbs_stb),
        .i_wbs_we(i_wbs_we),
        .rst(rst),
        .o_wbs_ack(o_wbs_ack),
        .o_wbs_dat(o_wbs_dat),
        .o_wbs_int(o_wbs_int)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            i_wbs_cyc = 0;
            i_wbs_stb = 0;
            i_wbs_adr = 0;
            i_wbs_dat = 0;
            i_wbs_we = 0;
            repeat(2) @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Reset State Initialization", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 32'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Basic Write Transaction", test_num);
            reset_dut();
            @(posedge clk);
            i_wbs_cyc = 1;
            i_wbs_stb = 1;
            i_wbs_we  = 1;
            i_wbs_adr = 32'h1234_5678;
            i_wbs_dat = 32'hDEAD_BEEF;


            wait(o_wbs_ack);
            #1;

            check_outputs(1'b1, o_wbs_dat, o_wbs_int);

            @(posedge clk);
            i_wbs_cyc = 0;
            i_wbs_stb = 0;
            i_wbs_we  = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Read Stored Address", test_num);
            reset_dut();


            @(posedge clk);
            i_wbs_cyc = 1; i_wbs_stb = 1; i_wbs_we = 1;
            i_wbs_adr = 32'hAAAA_BBBB; i_wbs_dat = 32'h1111_2222;
            wait(o_wbs_ack);
            @(posedge clk);
            i_wbs_cyc = 0; i_wbs_stb = 0;

            @(posedge clk);


            i_wbs_cyc = 1; i_wbs_stb = 1; i_wbs_we = 0;
            i_wbs_adr = 32'h0;
            wait(o_wbs_ack);


            #1;



            check_outputs(1'b1, 32'hAAAA_BBBB, o_wbs_int);

            @(posedge clk);
            i_wbs_cyc = 0; i_wbs_stb = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Consecutive Write and Update", test_num);
            reset_dut();


            @(posedge clk);
            i_wbs_cyc = 1; i_wbs_stb = 1; i_wbs_we = 1;
            i_wbs_adr = 32'h1111_1111; i_wbs_dat = 32'h0;
            wait(o_wbs_ack);
            @(posedge clk);


            i_wbs_adr = 32'h2222_2222; i_wbs_dat = 32'hFFFF_FFFF;
            wait(o_wbs_ack);
            @(posedge clk);
            i_wbs_cyc = 0; i_wbs_stb = 0;

            @(posedge clk);


            i_wbs_cyc = 1; i_wbs_stb = 1; i_wbs_we = 0;
            wait(o_wbs_ack);
            #1;

            check_outputs(1'b1, 32'h2222_2222, o_wbs_int);

            @(posedge clk);
            i_wbs_cyc = 0; i_wbs_stb = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Reset Persistence", test_num);
            reset_dut();


            @(posedge clk);
            i_wbs_cyc = 1; i_wbs_stb = 1; i_wbs_we = 1;
            i_wbs_adr = 32'h5555_AAAA; i_wbs_dat = 32'hC0DE_C0DE;
            wait(o_wbs_ack);
            @(posedge clk);
            i_wbs_cyc = 0; i_wbs_stb = 0;


            reset_dut();


            i_wbs_cyc = 1; i_wbs_stb = 1; i_wbs_we = 0;
            wait(o_wbs_ack);

            #1;


            check_outputs(1'b1, 32'h0, 1'b0);

            @(posedge clk);
            i_wbs_cyc = 0; i_wbs_stb = 0;
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
        input expected_o_wbs_ack;
        input [31:0] expected_o_wbs_dat;
        input expected_o_wbs_int;
        begin
            if (expected_o_wbs_ack === (expected_o_wbs_ack ^ o_wbs_ack ^ expected_o_wbs_ack) &&
                expected_o_wbs_dat === (expected_o_wbs_dat ^ o_wbs_dat ^ expected_o_wbs_dat) &&
                expected_o_wbs_int === (expected_o_wbs_int ^ o_wbs_int ^ expected_o_wbs_int)) begin
                $display("PASS");
                $display("  Outputs: o_wbs_ack=%b, o_wbs_dat=%h, o_wbs_int=%b",
                         o_wbs_ack, o_wbs_dat, o_wbs_int);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_wbs_ack=%b, o_wbs_dat=%h, o_wbs_int=%b",
                         expected_o_wbs_ack, expected_o_wbs_dat, expected_o_wbs_int);
                $display("  Got:      o_wbs_ack=%b, o_wbs_dat=%h, o_wbs_int=%b",
                         o_wbs_ack, o_wbs_dat, o_wbs_int);
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
        $dumpvars(0,clk, i_wbs_adr, i_wbs_cyc, i_wbs_dat, i_wbs_stb, i_wbs_we, rst, o_wbs_ack, o_wbs_dat, o_wbs_int);
    end

endmodule
