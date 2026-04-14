`timescale 1ns/1ps

module md5_simple_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] message;
    reg rst;
    reg start;
    wire [127:0] hash;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    md5_simple dut (
        .clk(clk),
        .message(message),
        .rst(rst),
        .start(start),
        .hash(hash),
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
            start = 0;
            message = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            repeat (2) @(posedge clk);
        end
        endtask
    task run_hash;

        input [511:0] msg_in;
        begin
            message = msg_in;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            fork : wait_ready
                begin
                    wait(ready === 1'b1);
                end
                begin
                    repeat (200) @(posedge clk);
                    $display("Error: Ready signal timed out");
                    disable wait_ready;
                end
            join
        end
        endtask

    task testcase001;

        begin
            $display("Test Case 001: All Zeros");
            reset_dut();
            run_hash(512'h0);

            #1;


            check_outputs(128'hd142129575822319f6f66348ef52a921, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: All Ones");
            reset_dut();
            run_hash({512{1'b1}});

            #1;


            check_outputs(128'he0892015093557e05e5428669e26210b, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Alternating Pattern 0xA5A5...");
            reset_dut();
            run_hash({64{8'hA5}});

            #1;


            check_outputs(128'h69642517596859871587823521369741, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Sequential Hashing (Block 1 then Block 2)");
            reset_dut();


            run_hash(512'h1);
            $display("  First block completed. Hash: %h", hash);


            run_hash(512'h2);

            #1;


            check_outputs(128'h45453673236321245869485231254789, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Reset recovery");
            reset_dut();
            message = 512'hDEADBEEF;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat (5) @(posedge clk);


            reset_dut();


            run_hash(512'h0);
            #1;

            check_outputs(128'hd142129575822319f6f66348ef52a921, 1'b1);
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
        input [127:0] expected_hash;
        input expected_ready;
        begin
            if (expected_hash === (expected_hash ^ hash ^ expected_hash) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: hash=%h, ready=%b",
                         hash, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash=%h, ready=%b",
                         expected_hash, expected_ready);
                $display("  Got:      hash=%h, ready=%b",
                         hash, ready);
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
        $dumpvars(0,clk, message, rst, start, hash, ready);
    end

endmodule
