`timescale 1ns/1ps

module md5_simple_tb;

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
    md5_simple dut (
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
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Input all zeros", test_num);
            reset_dut();
            data_in = 32'h0000_0000;


            repeat(2) @(posedge clk);
            #1;



            #1;




            check_outputs(32'h67452301 + 32'hEFCDAB89);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Input all ones", test_num);
            reset_dut();
            data_in = 32'hFFFF_FFFF;

            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(32'h98BADCFE + 32'h10325476);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Alternating bits (AAAA_AAAA)", test_num);
            reset_dut();
            data_in = 32'hAAAA_AAAA;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h5555_5555 ^ 32'hAAAA_AAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Alternating bits (5555_5555)", test_num);
            reset_dut();
            data_in = 32'h5555_5555;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(32'hFFFF_FFFF ^ 32'h5555_5555);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: MSB set (8000_0000)", test_num);
            reset_dut();
            data_in = 32'h8000_0000;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h8000_0000 + 32'h7FFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Data 32'h1234_5678", test_num);
            reset_dut();
            data_in = 32'h1234_5678;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h1234_5678 ^ 32'h8765_4321);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Re-verifying reset consistency", test_num);


            reset_dut();
            data_in = 32'hDEAD_BEEF;
            repeat(2) @(posedge clk);


            reset_dut();
            data_in = 32'hDEAD_BEEF;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(32'hDEAD_BEEF + 32'hCAFE_BABE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("md5_simple Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
