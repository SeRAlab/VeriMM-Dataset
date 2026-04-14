`timescale 1ns/1ps

module MD5_Hash_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] data_in;
    reg enable;
    reg rst;
    wire [127:0] hash_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    MD5_Hash dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
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
            enable = 0;
            data_in = 0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (512'h0)", test_num);
            reset_dut();

            data_in = 512'h0;
            enable = 1;
            @(posedge clk);
            enable = 0;


            repeat (100) @(posedge clk);


            #1;



            check_outputs(128'hf1642bb33f677054f02888941703666d);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Pattern (0xA5...)", test_num);
            reset_dut();

            data_in = {64{8'hA5}};
            enable = 1;
            @(posedge clk);
            enable = 0;

            repeat (100) @(posedge clk);


            #1;



            check_outputs(128'h0e97669d03176664e4325a257e1704df);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones (512'hFFFF...)", test_num);
            reset_dut();

            data_in = {16{32'hFFFFFFFF}};
            enable = 1;
            @(posedge clk);
            enable = 0;

            repeat (100) @(posedge clk);


            #1;



            check_outputs(128'h4b719468160911739c394747209930f4);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("MD5_Hash Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        
        
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
        input [127:0] expected_hash_out;
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
        $dumpvars(0,clk, data_in, enable, rst, hash_out);
    end

endmodule
