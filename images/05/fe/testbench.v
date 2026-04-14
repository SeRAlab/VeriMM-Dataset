`timescale 1ns/1ps

module md5_hash_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] message;
    reg reset;
    reg valid;
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
        .reset(reset),
        .valid(valid),
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
            reset = 1;
            valid = 0;
            message = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 512 bits of zeros", test_num);
            reset_dut();

            message = 512'h0;
            valid = 1;
            @(posedge clk);
            #1 valid = 0;


            wait(done == 1);
            #1;
            #1;

            check_outputs(1'b1, 128'h3b06a054283d7351650335d6428f7315);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 512 bits of ones", test_num);
            reset_dut();

            message = {16{32'hFFFFFFFF}};
            valid = 1;
            @(posedge clk);
            #1 valid = 0;

            wait(done == 1);
            #1;
            #1;

            check_outputs(1'b1, 128'h0e461b9609c25f75e9668d8794834861);
        end
        endtask

    task testcase003;

        integer i;
        reg [511:0] pattern;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Incremental pattern", test_num);
            reset_dut();

            for (i = 0; i < 64; i = i + 1) begin
                pattern[i*8 +: 8] = i[7:0];
            end

            message = pattern;
            valid = 1;
            @(posedge clk);
            #1 valid = 0;

            wait(done == 1);
            #1;

            #1;


            check_outputs(1'b1, 128'h394205779c6d48386f7f329d5b0c950d);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating bits (0xAA)", test_num);
            reset_dut();

            message = {64{8'hAA}};
            valid = 1;
            @(posedge clk);
            #1 valid = 0;

            wait(done == 1);
            #1;
            #1;

            check_outputs(1'b1, 128'ha3997235555d496e62c4cf2f02693994);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Repeating 0x12345678", test_num);
            reset_dut();

            message = {16{32'h12345678}};
            valid = 1;
            @(posedge clk);
            #1 valid = 0;

            wait(done == 1);
            #1;
            #1;

            check_outputs(1'b1, 128'h5475e648f0290680387537b809a74423);
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
        $dumpvars(0,clk, message, reset, valid, done, hash);
    end

endmodule
