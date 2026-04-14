`timescale 1ns/1ps

module sha256_simple_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg rst;
    wire [31:0] hash_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sha256_simple dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .hash_out(hash_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 32'h0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Zero Input");
            reset_dut();
            test_num = 1;
            data_in = 32'h00000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hABCD1234);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: All-Ones Input");
            reset_dut();
            test_num = 2;
            data_in = 32'hFFFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h5432EDCB);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Constant Match Input");
            reset_dut();
            test_num = 3;
            data_in = 32'hABCD1234;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Alternating Bits");
            reset_dut();
            test_num = 4;
            data_in = 32'h55555555;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFE984761);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Hex Pattern 0x12345678");
            reset_dut();
            test_num = 5;
            data_in = 32'h12345678;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hB9F9444C);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Hex Pattern 0xDEADBEEF");
            reset_dut();
            test_num = 6;
            data_in = 32'hDEADBEEF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h7560ACDB);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sha256_simple Testbench");
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
        $dumpvars(0,clk, data_in, rst, hash_out);
    end

endmodule
