`timescale 1ns/1ps

module sha256_simple_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] data_in;
    reg rst;
    wire [7:0] hash_out;

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
            data_in = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All Zeros Input", test_num);
            reset_dut();
            data_in = 256'h0;

            repeat(80) @(posedge clk);
            #1;

            check_outputs(8'hED);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: All Ones Input", test_num);
            reset_dut();
            data_in = {128{2'b11}};
            repeat(80) @(posedge clk);
            #1;

            check_outputs(8'h3C);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Test Case %0d: Incremental Pattern", test_num);
            reset_dut();
            for (i = 0; i < 32; i = i + 1) begin
                data_in[i*8 +: 8] = i[7:0];
            end
            repeat(80) @(posedge clk);
            #1;

            check_outputs(8'hA3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Alternating Bits (0x55)", test_num);
            reset_dut();
            data_in = {32{8'h55}};
            repeat(80) @(posedge clk);
            #1;

            check_outputs(8'h74);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Specific Hex Constant", test_num);
            reset_dut();
            data_in = 256'h0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef;
            repeat(80) @(posedge clk);
            #1;

            check_outputs(8'h41);
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
        input [7:0] expected_hash_out;
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
