`timescale 1ns/1ps

module md5_hash_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] message;
    reg rst;
    reg start;
    wire done;
    wire [127:0] hash;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    md5_hash dut (
        .clk(clk),
        .message(message),
        .rst(rst),
        .start(start),
        .done(done),
        .hash(hash)
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
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 512-bit block of zeros", test_num);
            reset_dut();
            message = 512'h0;
            start = 1;
            @(posedge clk);
            start = 0;
            while (!done) @(posedge clk);
            #1;

            check_outputs(1'b1, 128'h3b5d3c7d207e37dce05d38c20574e80a);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: MD5 Padded Empty String", test_num);
            reset_dut();

            message = 512'h0;
            message[31:0] = 32'h80000000;
            start = 1;
            @(posedge clk);
            start = 0;
            while (!done) @(posedge clk);
            #1;

            check_outputs(1'b1, 128'hd41d8cd98f00b204e9800998ecf8427e);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: MD5 Padded String 'abc'", test_num);
            reset_dut();
            message = 512'h0;

            message[31:0] = 32'h80636261;

            message[479:448] = 32'h00000018;
            start = 1;
            @(posedge clk);
            start = 0;
            while (!done) @(posedge clk);
            #1;

            check_outputs(1'b1, 128'h900150983cd24fb0d6963f7d28e17f72);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: MD5 Padded String 'message digest'", test_num);
            reset_dut();
            message = 512'h0;

            message[31:0]   = 32'h7373656d;
            message[63:32]  = 32'h20656761;
            message[95:64]  = 32'h65676964;
            message[127:96] = 32'h807473;
            message[479:448] = 32'h00000070;
            start = 1;
            @(posedge clk);
            start = 0;
            while (!done) @(posedge clk);
            #1;

            check_outputs(1'b1, 128'hf96b697d7cb7938d525a2f31aaf161d0);
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
        input expected_done;
        input [127:0] expected_hash;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_hash === (expected_hash ^ hash ^ expected_hash)) begin
                $display("PASS");
                $display("  Outputs: done=%b, hash=%h",
                         done, hash);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, hash=%h",
                         expected_done, expected_hash);
                $display("  Got:      done=%b, hash=%h",
                         done, hash);
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
        $dumpvars(0,clk, message, rst, start, done, hash);
    end

endmodule
