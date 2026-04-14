`timescale 1ns/1ps

module lfsr_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg reset;
    reg [31:0] seed;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr_32bit dut (
        .clk(clk),
        .load(load),
        .reset(reset),
        .seed(seed),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        load = 0;
        seed = 0;
        @(posedge clk);
        #2 reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Resetting DUT...", test_num);
        reset_dut();
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Loading Seed 32'hACE12345...", test_num);
        reset_dut();
        seed = 32'hACE12345;
        load = 1;
        @(posedge clk);
        #2 load = 0;
        #1;

        check_outputs(32'hACE12345);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shifting MSB Tap (x^32)...", test_num);
        reset_dut();
        seed = 32'h80000000;
        load = 1;
        @(posedge clk);
        #2 load = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shifting x^22 Tap (bit 21)...", test_num);
        reset_dut();
        seed = 32'h00200000;
        load = 1;
        @(posedge clk);
        #2 load = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h00400001);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shifting x^21 Tap (bit 20)...", test_num);
        reset_dut();
        seed = 32'h00100000;
        load = 1;
        @(posedge clk);
        #2 load = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h00200001);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shifting x^1 Tap (bit 0)...", test_num);
        reset_dut();
        seed = 32'h00000001;
        load = 1;
        @(posedge clk);
        #2 load = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h00000003);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shifting 3 times from 0x80000000...", test_num);
        reset_dut();
        seed = 32'h80000000;
        load = 1;
        @(posedge clk);
        #2 load = 0;
        repeat(3) @(posedge clk);
        #2;
        #1;

        check_outputs(32'h00000007);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shifting All-Ones Seed...", test_num);
        reset_dut();
        seed = 32'hFFFFFFFF;
        load = 1;
        @(posedge clk);
        #2 load = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hFFFFFFFE);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lfsr_32bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        $dumpvars(0,clk, load, reset, seed, out);
    end

endmodule
