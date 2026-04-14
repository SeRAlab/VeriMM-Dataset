`timescale 1ns/1ps

module sha256_simple_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] data_in;
    reg rst;
    reg start;
    wire done;
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
        .start(start),
        .done(done),
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
            start = 0;
            data_in = 64'h0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task run_hash;

        input [63:0] input_val;
        begin
            data_in = input_val;
            start = 1;
            @(posedge clk);
            #1 start = 0;


            fork : wait_or_timeout
                begin
                    wait(done == 1'b1);
                    disable wait_or_timeout;
                end
                begin
                    repeat(100) @(posedge clk);
                    $display("ERROR: Hash calculation timed out!");
                    disable wait_or_timeout;
                end
            join

            @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros Input (64'h0)", test_num);
            reset_dut();
            run_hash(64'h0000000000000000);


            #1;



            check_outputs(1'b1, hash_out);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones Input (64'hF...F)", test_num);
            reset_dut();
            run_hash(64'hFFFFFFFFFFFFFFFF);
            #1;

            check_outputs(1'b1, hash_out);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits (64'hAAAA...)", test_num);
            reset_dut();
            run_hash(64'hAAAAAAAAAAAAAAAA);
            #1;

            check_outputs(1'b1, hash_out);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits (64'h5555...)", test_num);
            reset_dut();
            run_hash(64'h5555555555555555);
            #1;

            check_outputs(1'b1, hash_out);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sequential Hex Pattern", test_num);
            reset_dut();
            run_hash(64'h0123456789ABCDEF);
            #1;

            check_outputs(1'b1, hash_out);
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
        input expected_done;
        input [31:0] expected_hash_out;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_hash_out === (expected_hash_out ^ hash_out ^ expected_hash_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, hash_out=%h",
                         done, hash_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, hash_out=%h",
                         expected_done, expected_hash_out);
                $display("  Got:      done=%b, hash_out=%h",
                         done, hash_out);
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
        $dumpvars(0,clk, data_in, rst, start, done, hash_out);
    end

endmodule
