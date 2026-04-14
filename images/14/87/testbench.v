`timescale 1ns/1ps

module md5_hash_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] message_in;
    reg reset;
    reg start;
    wire done;
    wire [127:0] hash_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    md5_hash dut (
        .clk(clk),
        .message_in(message_in),
        .reset(reset),
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
            reset = 1;
            start = 0;
            message_in = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %03d: MD5 of Empty String (Padded Block)", test_num);
            reset_dut();



            message_in = 512'h0;
            message_in[31:0] = 32'h00000080;

            start = 1;
            @(posedge clk);
            start = 0;


            wait(done);
            @(posedge clk);


            #1;



            check_outputs(1, 128'hd41d8cd98f00b204e9800998ecf8427e);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %03d: MD5 of 'a' (Padded Block)", test_num);
            reset_dut();


            message_in = 512'h0;
            message_in[31:0]   = 32'h00008061;
            message_in[479:448] = 32'h00000008;

            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);


            #1;



            check_outputs(1, 128'h0cc175b9c0f1b6a831c399e269772661);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %03d: MD5 of 'abc' (Padded Block)", test_num);
            reset_dut();


            message_in = 512'h0;
            message_in[31:0]   = 32'h80636261;
            message_in[479:448] = 32'h00000018;

            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);


            #1;



            check_outputs(1, 128'h900150983cd24fb0d6963f7d28e17f72);
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
        input [127:0] expected_hash_out;
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
        $dumpvars(0,clk, message_in, reset, start, done, hash_out);
    end

endmodule
