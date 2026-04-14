`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg c1;
    reg c3;
    reg clk;
    reg clk7_en;
    reg [63:0] data_in;
    reg [1:0] fmode;
    reg hires;
    reg load;
    reg [7:0] scroll;
    reg shres;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c1(c1),
        .c3(c3),
        .clk(clk),
        .clk7_en(clk7_en),
        .data_in(data_in),
        .fmode(fmode),
        .hires(hires),
        .load(load),
        .scroll(scroll),
        .shres(shres),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            c1 = 0;
            c3 = 0;
            clk7_en = 0;
            data_in = 64'h0;
            fmode = 2'b00;
            hires = 0;
            load = 0;
            scroll = 8'h0;
            shres = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            data_in = 64'h8000_0000_0000_0000;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            clk7_en = 1;

            repeat(2) @(posedge clk);
            #1;
            $display("Test %0d: Basic loading, check MSB output (No Scroll)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            data_in = 64'h0000_0000_0000_0001;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            clk7_en = 1;
            repeat(2) @(posedge clk);
            #1;
            $display("Test %0d: Check output is 0 when MSB is 0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            data_in = 64'h8000_0000_0000_0000;

            scroll = 8'h01;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            clk7_en = 1;
            repeat(2) @(posedge clk);
            #1;
            $display("Test %0d: Scroll=1 check (MSB should be delayed)", test_num);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            fmode = 2'b11;
            data_in = 64'hAAAA_AAAA_AAAA_AAAA;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            clk7_en = 1;

            repeat(5) @(posedge clk);
            #1;
            $display("Test %0d: FMODE 3 sequence check", test_num);


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            hires = 1;
            data_in = 64'hC000_0000_0000_0000;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            clk7_en = 1;
            repeat(2) @(posedge clk);
            #1;
            $display("Test %0d: HIRES mode output check", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            data_in = 64'hFFFF_FFFF_FFFF_FFFF;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            clk7_en = 1;
            repeat(5) @(posedge clk);

            reset_dut();
            #1;
            $display("Test %0d: Reset/Disable state check", test_num);

            #1;


            check_outputs(1'b0);
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
        input expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
        $dumpvars(0,c1, c3, clk, clk7_en, data_in, fmode, hires, load, scroll, shres, out);
    end

endmodule
