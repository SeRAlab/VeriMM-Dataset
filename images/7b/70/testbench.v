`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] addr;
    reg clk;
    reg [31:0] data;
    reg we;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .data(data),
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
        addr = 0;
        data = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Write and Read", test_num);
        reset_dut();

        @(negedge clk);
        we = 1;
        addr = 10'h005;
        data = 32'hDEADBEEF;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Persistent Read", test_num);
        reset_dut();

        @(negedge clk);
        we = 1;
        addr = 10'h010;
        data = 32'hCAFEBABE;
        @(posedge clk);

        @(negedge clk);
        we = 0;
        addr = 10'h010;
        data = 32'hFFFFFFFF;
        @(posedge clk);

        #2;
        #1;

        check_outputs(32'hCAFEBABE);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Memory Independence", test_num);
        reset_dut();


        @(negedge clk);
        we = 1;
        addr = 10'h0A1;
        data = 32'h11112222;
        @(posedge clk);


        @(negedge clk);
        we = 1;
        addr = 10'h0B2;
        data = 32'h33334444;
        @(posedge clk);


        @(negedge clk);
        we = 0;
        addr = 10'h0A1;
        @(posedge clk);

        #2;
        #1;

        check_outputs(32'h11112222);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary Address (0x3FF)", test_num);
        reset_dut();

        @(negedge clk);
        we = 1;
        addr = 10'h3FF;
        data = 32'hAAAAAAAA;
        @(posedge clk);

        @(negedge clk);
        we = 0;
        addr = 10'h3FF;
        @(posedge clk);

        #2;
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Data Overwrite", test_num);
        reset_dut();

        @(negedge clk);
        we = 1;
        addr = 10'h055;
        data = 32'h00001111;
        @(posedge clk);

        @(negedge clk);
        we = 1;
        addr = 10'h055;
        data = 32'h55556666;
        @(posedge clk);

        #2;
        #1;

        check_outputs(32'h55556666);
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
        input [31:0] expected_out;
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
        $dumpvars(0,addr, clk, data, we, out);
    end

endmodule
