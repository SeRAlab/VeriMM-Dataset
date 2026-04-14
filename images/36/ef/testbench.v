`timescale 1ns/1ps

module md5_hash_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] data_in;
    reg rst;
    reg valid;
    wire [127:0] hash_out;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    md5_hash dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .valid(valid),
        .hash_out(hash_out),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid = 0;
            data_in = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: All Zeros Input", test_num);
            reset_dut();

            data_in = 512'h0;
            valid = 1;
            @(posedge clk);
            valid = 0;


            wait(ready == 1);
            @(posedge clk);



            #1;




            check_outputs(128'h7bf05973562309f44f56f34e68e4c76b, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Specific Pattern", test_num);
            reset_dut();


            data_in = {64'h0123456789ABCDEF, 448'h0};
            valid = 1;
            @(posedge clk);
            valid = 0;

            wait(ready == 1);
            @(posedge clk);


            #1;



            check_outputs(128'h69612c953580550c60f252445173163a, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: All Ones Input", test_num);
            reset_dut();


            data_in = {64'hFFFFFFFFFFFFFFFF, 448'h0};
            valid = 1;
            @(posedge clk);
            valid = 0;

            wait(ready == 1);
            @(posedge clk);


            #1;



            check_outputs(128'h4e495240c0371a5359a607887d10c2c3, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Alternating Bits", test_num);
            reset_dut();

            data_in = {64'h55555555AAAAAAAB, 448'h0};
            valid = 1;
            @(posedge clk);
            valid = 0;

            wait(ready == 1);
            @(posedge clk);

            #1;


            check_outputs(128'h4d098e9460d37e6f3b064c127453051a, 1'b1);
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
        input expected_ready;
        begin
            if (expected_hash_out === (expected_hash_out ^ hash_out ^ expected_hash_out) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: hash_out=%h, ready=%b",
                         hash_out, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash_out=%h, ready=%b",
                         expected_hash_out, expected_ready);
                $display("  Got:      hash_out=%h, ready=%b",
                         hash_out, ready);
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
        $dumpvars(0,clk, data_in, rst, valid, hash_out, ready);
    end

endmodule
