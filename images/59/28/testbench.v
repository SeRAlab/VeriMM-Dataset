`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CRY;
    reg bank;
    reg clk;
    reg [7:0] in;
    reg reset;
    reg setCRY;
    reg ureg;
    reg we;
    wire [7:0] curr_out;
    wire [7:0] read_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CRY(CRY),
        .bank(bank),
        .clk(clk),
        .in(in),
        .reset(reset),
        .setCRY(setCRY),
        .ureg(ureg),
        .we(we),
        .curr_out(curr_out),
        .read_out(read_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            CRY = 0;
            bank = 0;
            in = 0;
            setCRY = 0;
            ureg = 0;
            we = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset check...");
            reset_dut();


            ureg = 0; bank = 0;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Write 0xA5 to Bank 0 (uCR)...");
            reset_dut();
            @(posedge clk);
            we = 1;
            bank = 0;
            in = 8'hA5;
            @(posedge clk);
            we = 0;
            ureg = 1;
            bank = 0;
            #1;

            check_outputs(8'hA5, 8'hA5);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Write 0x5A to Bank 1 (sCR)...");
            reset_dut();
            @(posedge clk);
            we = 1;
            bank = 1;
            in = 8'h5A;
            @(posedge clk);
            we = 0;
            ureg = 0;
            bank = 1;
            #1;

            check_outputs(8'h5A, 8'h5A);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Mixed access (uCR=0xAA, sCR=0xBB)...");
            reset_dut();

            @(posedge clk);
            we = 1; bank = 0; in = 8'hAA;
            @(posedge clk);

            we = 1; bank = 1; in = 8'hBB;
            @(posedge clk);
            we = 0;

            ureg = 1; bank = 1;
            #1;

            check_outputs(8'hAA, 8'hBB);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: setCRY bit set (uCR)...");
            reset_dut();

            @(posedge clk);
            we = 1; bank = 0; in = 8'hFE;
            @(posedge clk);

            we = 0; setCRY = 1; CRY = 1; bank = 0;
            @(posedge clk);
            setCRY = 0;
            ureg = 1; bank = 0;
            #1;

            check_outputs(8'hFF, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: setCRY bit clear (sCR)...");
            reset_dut();

            @(posedge clk);
            we = 1; bank = 1; in = 8'h01;
            @(posedge clk);

            we = 0; setCRY = 1; CRY = 0; bank = 1;
            @(posedge clk);
            setCRY = 0;
            ureg = 0; bank = 1;
            #1;

            check_outputs(8'h00, 8'h00);
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
        input [7:0] expected_curr_out;
        input [7:0] expected_read_out;
        begin
            if (expected_curr_out === (expected_curr_out ^ curr_out ^ expected_curr_out) &&
                expected_read_out === (expected_read_out ^ read_out ^ expected_read_out)) begin
                $display("PASS");
                $display("  Outputs: curr_out=%h, read_out=%h",
                         curr_out, read_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: curr_out=%h, read_out=%h",
                         expected_curr_out, expected_read_out);
                $display("  Got:      curr_out=%h, read_out=%h",
                         curr_out, read_out);
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
        $dumpvars(0,CRY, bank, clk, in, reset, setCRY, ureg, we, curr_out, read_out);
    end

endmodule
