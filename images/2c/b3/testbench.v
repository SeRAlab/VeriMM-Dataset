`timescale 1ns/1ps

module md5_hash_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] data_in;
    reg data_valid;
    reg reset;
    wire [127:0] hash_out;
    wire hash_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    md5_hash dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .reset(reset),
        .hash_out(hash_out),
        .hash_valid(hash_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_valid = 0;
            data_in = 0;
            repeat(5) @(posedge clk);
            reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: MD5 of Empty String", test_num);
            reset_dut();

            @(posedge clk);




            data_in = 512'h80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            data_valid = 1;

            @(posedge clk);
            data_valid = 0;


            wait(hash_valid === 1);


            #1;



            check_outputs(128'hd41d8cd98f00b204e9800998ecf8427e, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: MD5 of 'a'", test_num);
            reset_dut();

            @(posedge clk);




            data_in = 512'h61800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000000000000;
            data_valid = 1;

            @(posedge clk);
            data_valid = 0;

            wait(hash_valid === 1);


            #1;



            check_outputs(128'h0cc175b9c0f1b6a831c399e269772661, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: MD5 of 'abc'", test_num);
            reset_dut();

            @(posedge clk);




            data_in = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001800000000000000;
            data_valid = 1;

            @(posedge clk);
            data_valid = 0;

            wait(hash_valid === 1);


            #1;



            check_outputs(128'h900150983cd24fb0d6963f7d28e17f72, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: MD5 of 'message digest'", test_num);
            reset_dut();

            @(posedge clk);


            data_in = 512'h6d657373616765206469676573748000000000000000000000000000000000000000000000000000000000000000000000000000000000007000000000000000;
            data_valid = 1;

            @(posedge clk);
            data_valid = 0;

            wait(hash_valid === 1);


            #1;



            check_outputs(128'hf96b697d7cb7938d525a2f31aaf161d0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Raw 512-bit Block of Zeros", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 512'h0;
            data_valid = 1;

            @(posedge clk);
            data_valid = 0;

            wait(hash_valid === 1);




            #1;





            check_outputs(128'h70e050419409848f220377c8e8ef6e04, 1'b1);
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
        input [127:0] expected_hash_out;
        input expected_hash_valid;
        begin
            if (expected_hash_out === (expected_hash_out ^ hash_out ^ expected_hash_out) &&
                expected_hash_valid === (expected_hash_valid ^ hash_valid ^ expected_hash_valid)) begin
                $display("PASS");
                $display("  Outputs: hash_out=%h, hash_valid=%b",
                         hash_out, hash_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash_out=%h, hash_valid=%b",
                         expected_hash_out, expected_hash_valid);
                $display("  Got:      hash_out=%h, hash_valid=%b",
                         hash_out, hash_valid);
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
        $dumpvars(0,clk, data_in, data_valid, reset, hash_out, hash_valid);
    end

endmodule
