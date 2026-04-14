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
            repeat (2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: MD5 of Empty String Block", test_num);
            reset_dut();


            data_in = 512'h0;
            data_in[511:504] = 8'h80;

            valid = 1;
            @(posedge clk);
            valid = 0;


            wait(ready === 1);
            @(posedge clk);


            #1;



            check_outputs(128'hd41d8cd98f00b204e9800998ecf8427e, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: MD5 of 'abc' Block", test_num);
            reset_dut();






            data_in = 512'h0;
            data_in[511:480] = 32'h61626380;
            data_in[7:0]     = 8'h18;

            valid = 1;
            @(posedge clk);
            valid = 0;

            wait(ready === 1);
            @(posedge clk);


            #1;



            check_outputs(128'h900150983cd24fb0d6963f7d28e17f72, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: High Toggle All-Ones Block", test_num);
            reset_dut();

            data_in = {16{32'hFFFFFFFF}};
            valid = 1;
            @(posedge clk);
            valid = 0;

            wait(ready === 1);
            @(posedge clk);



            if (ready === 1'b1 && hash_out !== 128'hx) begin
                $display("PASS: Logic completed with stable output");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Logic resulted in X or failed to ready");
                fail_count = fail_count + 1;
            end
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
