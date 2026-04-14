`timescale 1ns/1ps

module md5_hash_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg reset;
    wire [31:0] hash_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    md5_hash dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .hash_out(hash_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Input = 32'h00000000", test_num);
            reset_dut();
            data_in = 32'h0000_0000;

            repeat(20) @(posedge clk);

            #1;


            check_outputs(32'h69C324B1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Input = 32'hFFFFFFFF", test_num);
            reset_dut();
            data_in = 32'hFFFF_FFFF;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(32'hA2D1E540);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Input = 32'hAAAAAAAA", test_num);
            reset_dut();
            data_in = 32'hAAAA_AAAA;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(32'h5D3B2A10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Input = 32'h12345678", test_num);
            reset_dut();
            data_in = 32'h1234_5678;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(32'hBC892145);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Input = 32'hDEADBEEF", test_num);
            reset_dut();
            data_in = 32'hDEAD_BEEF;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(32'h74A1F209);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("md5_hash Testbench");
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
        input [31:0] expected_hash_out;
        begin
            if (expected_hash_out === (expected_hash_out ^ hash_out ^ expected_hash_out)) begin
                $display("PASS");
                $display("  Outputs: hash_out=%h",
                         hash_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash_out=%h",
                         expected_hash_out);
                $display("  Got:      hash_out=%h",
                         hash_out);
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
        $dumpvars(0,clk, data_in, reset, hash_out);
    end

endmodule
