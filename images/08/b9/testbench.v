`timescale 1ns/1ps

module crc_4bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg enable;
    reg [3:0] poly;
    reg rst;
    wire [3:0] crc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crc_4bit dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .poly(poly),
        .rst(rst),
        .crc_out(crc_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 0;
            data_in = 4'b0;
            poly = 4'b0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Data=4'hA, Poly=4'h3 (x^4 + x + 1)", test_num);
            reset_dut();
            data_in = 4'hA;
            poly = 4'h3;
            enable = 1;

            repeat(4) @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(4'hD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Data=4'hF, Poly=4'h3 (x^4 + x + 1)", test_num);
            reset_dut();
            data_in = 4'hF;
            poly = 4'h3;
            enable = 1;
            repeat(4) @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Data=4'h0, Poly=4'hB (x^4 + x^3 + x + 1)", test_num);
            reset_dut();
            data_in = 4'h0;
            poly = 4'hB;
            enable = 1;
            repeat(4) @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Data=4'h8, Poly=4'h9 (x^4 + x^3 + 1)", test_num);
            reset_dut();
            data_in = 4'h8;
            poly = 4'h9;
            enable = 1;
            repeat(4) @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Data=4'h5, Poly=4'h5 (x^4 + x^2 + 1)", test_num);
            reset_dut();
            data_in = 4'h5;
            poly = 4'h5;
            enable = 1;
            repeat(4) @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(4'h4);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("crc_4bit Testbench");
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
        input [3:0] expected_crc_out;
        begin
            if (expected_crc_out === (expected_crc_out ^ crc_out ^ expected_crc_out)) begin
                $display("PASS");
                $display("  Outputs: crc_out=%h",
                         crc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc_out=%h",
                         expected_crc_out);
                $display("  Got:      crc_out=%h",
                         crc_out);
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
        $dumpvars(0,clk, data_in, enable, poly, rst, crc_out);
    end

endmodule
