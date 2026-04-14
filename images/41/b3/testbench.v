`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] addr;
    reg clk;
    reg [7:0] in;
    reg we;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .in(in),
        .we(we),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        we = 0;
        addr = 16'h0;
        in = 8'h0;
        @(negedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();


        @(negedge clk);
        addr = 16'h1001;
        in = PASS_VAL;
        we = 1;
        @(negedge clk);
        in = 8'hD1;
        we = 1;
        @(negedge clk);
        we = 0;


        @(negedge clk);
        addr = 16'h1001;
        in = PASS_VAL;
        we = 0;
        @(negedge clk);

        #1;
        $display("Testcase %0d: Authorized Write/Read", test_num);
        #1;

        check_outputs(8'hD1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();


        @(negedge clk);
        addr = 16'h2002;
        in = 8'hFF;
        we = 1;
        @(negedge clk);
        in = 8'hE2;
        we = 1;
        @(negedge clk);
        we = 0;


        @(negedge clk);
        addr = 16'h2002;
        in = PASS_VAL;
        we = 0;
        @(negedge clk);

        #1;
        $display("Testcase %0d: Unauthorized Write (Wrong Password)", test_num);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();


        @(negedge clk);
        addr = 16'h3003;
        in = PASS_VAL;
        we = 1;
        @(negedge clk);
        in = 8'hB3;
        we = 1;
        @(negedge clk);
        we = 0;


        @(negedge clk);
        addr = 16'h3003;
        in = 8'h00;
        we = 0;
        @(negedge clk);

        #1;
        $display("Testcase %0d: Unauthorized Read (Wrong Password)", test_num);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();


        @(negedge clk);
        addr = 16'hFFFF;
        in = PASS_VAL;
        we = 1;
        @(negedge clk);
        in = 8'hAA;
        we = 1;
        @(negedge clk);


        addr = 16'hFFFF;
        in = PASS_VAL;
        we = 0;
        @(negedge clk);

        #1;
        $display("Testcase %0d: Boundary Address and Integrity Check", test_num);
        #1;

        check_outputs(8'hAA);
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
        input [7:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
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
        $dumpvars(0,addr, clk, in, we, out);
    end

endmodule
