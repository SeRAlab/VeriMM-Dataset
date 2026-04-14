`timescale 1ns/1ps

module hmac_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] key;
    reg [127:0] message;
    reg rst;
    reg start;
    wire done;
    wire [127:0] hash;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hmac dut (
        .clk(clk),
        .key(key),
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
            key = 0;
            message = 0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("\nRunning Testcase %0d: Zero Key and Message", test_num);
            key = 128'h0;
            message = 128'h0;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 128'h6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("\nRunning Testcase %0d: All Ones Message", test_num);
            key = 128'h0;
            message = {128{1'b1}};
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 128'h95959595959595959595959595959595);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("\nRunning Testcase %0d: Specific Key and Message", test_num);
            key = 128'hdeadbeefdeadbeefdeadbeefdeadbeef;
            message = 128'h0123456789abcdeffedcba9876543210;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 128'h0123456789abcdeffedcba9876543210 ^ 128'h6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("\nRunning Testcase %0d: Alternating Bit Pattern", test_num);
            key = 128'h55555555555555555555555555555555;
            message = 128'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 128'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa ^ 128'h6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("\nRunning Testcase %0d: Sequential Operations", test_num);


            key = 128'h0;
            message = 128'h11223344556677889900aabbccddeeff;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);


            @(posedge clk);
            key = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            message = 128'h0;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 128'h6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hmac Testbench");
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
        $dumpvars(0,clk, key, message, rst, start, done, hash);
    end

endmodule
