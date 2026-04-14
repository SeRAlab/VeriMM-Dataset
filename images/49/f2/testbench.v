`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg rst_n;
    reg shift_en;
    wire [3:0] ram_out;
    wire [3:0] shift_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .rst_n(rst_n),
        .shift_en(shift_en),
        .ram_out(ram_out),
        .shift_out(shift_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            data_in = 0;
            shift_en = 0;

            repeat(2) @(posedge clk);
            #2 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Initial State Check", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single bit shift (data_in=1)", test_num);
            reset_dut();

            shift_en = 1;
            data_in = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'h0, 4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift sequence 1-0-1-1", test_num);
            reset_dut();

            shift_en = 1;
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);
            #1;


            #1;



            check_outputs(4'h0, 4'hB);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Enable control check", test_num);
            reset_dut();


            shift_en = 1;
            data_in = 1;
            @(posedge clk);


            shift_en = 0;
            data_in = 0;
            repeat(3) @(posedge clk);
            #1;


            #1;



            check_outputs(4'h0, 4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Continuous shift overflow check", test_num);
            reset_dut();

            shift_en = 1;

            data_in = 1; repeat(4) @(posedge clk);
            data_in = 0; @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0, 4'hE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating pattern 1010", test_num);
            reset_dut();

            shift_en = 1;
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
            #1;


            #1;



            check_outputs(4'h0, 4'hA);
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
        input [3:0] expected_ram_out;
        input [3:0] expected_shift_out;
        begin
            if (expected_ram_out === (expected_ram_out ^ ram_out ^ expected_ram_out) &&
                expected_shift_out === (expected_shift_out ^ shift_out ^ expected_shift_out)) begin
                $display("PASS");
                $display("  Outputs: ram_out=%h, shift_out=%h",
                         ram_out, shift_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ram_out=%h, shift_out=%h",
                         expected_ram_out, expected_shift_out);
                $display("  Got:      ram_out=%h, shift_out=%h",
                         ram_out, shift_out);
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
        $dumpvars(0,clk, data_in, rst_n, shift_en, ram_out, shift_out);
    end

endmodule
