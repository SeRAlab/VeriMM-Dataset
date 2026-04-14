`timescale 1ns/1ps

module sha256_hash_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] message;
    reg reset;
    reg valid_in;
    wire [255:0] hash;
    wire ready_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sha256_hash dut (
        .clk(clk),
        .message(message),
        .reset(reset),
        .valid_in(valid_in),
        .hash(hash),
        .ready_out(ready_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            valid_in = 0;
            message = 0;
            repeat (5) @(posedge clk);
            #1 reset = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: All Zeros (512 bits)", test_num);
            reset_dut();

            message = 512'h0;
            valid_in = 1;
            @(posedge clk);
            #1 valid_in = 0;


            while (!ready_out) @(posedge clk);


            #1;



            check_outputs(256'hda5698be17b9b46962335799779f4f83e1f23819b03361a2f73d4fb44c929858, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: All Ones (512 bits)", test_num);
            reset_dut();

            message = {16{32'hFFFFFFFF}};
            valid_in = 1;
            @(posedge clk);
            #1 valid_in = 0;

            while (!ready_out) @(posedge clk);


            #1;



            check_outputs(256'h849c714c330054045f4172573216892e626154625b508f7f2595f54070a91178, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: Padded 'abc' string", test_num);
            reset_dut();


            message = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;
            valid_in = 1;
            @(posedge clk);
            #1 valid_in = 0;

            while (!ready_out) @(posedge clk);


            #1;



            check_outputs(256'hba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: 64 bytes of 'a'", test_num);
            reset_dut();

            message = {64{8'h61}};
            valid_in = 1;
            @(posedge clk);
            #1 valid_in = 0;

            while (!ready_out) @(posedge clk);


            #1;



            check_outputs(256'hf4448550130f14065666f27b5870b2241cfb4334f59e66509f6e3c09e3e73507, 1'b1);
        end
        endtask

    task testcase005;

        reg [511:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: Incrementing Sequence", test_num);
            reset_dut();

            for (i = 0; i < 64; i = i + 1) begin
                pattern[(63-i)*8 +: 8] = i[7:0];
            end

            message = pattern;
            valid_in = 1;
            @(posedge clk);
            #1 valid_in = 0;

            while (!ready_out) @(posedge clk);


            #1;



            check_outputs(256'hcbc90117a783685e9821966526118d053702436d6560946d5c645479010e9603, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sha256_hash Testbench");
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
        input [255:0] expected_hash;
        input expected_ready_out;
        begin
            if (expected_hash === (expected_hash ^ hash ^ expected_hash) &&
                expected_ready_out === (expected_ready_out ^ ready_out ^ expected_ready_out)) begin
                $display("PASS");
                $display("  Outputs: hash=%h, ready_out=%b",
                         hash, ready_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash=%h, ready_out=%b",
                         expected_hash, expected_ready_out);
                $display("  Got:      hash=%h, ready_out=%b",
                         hash, ready_out);
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
        $dumpvars(0,clk, message, reset, valid_in, hash, ready_out);
    end

endmodule
