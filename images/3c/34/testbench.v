`timescale 1ns/1ps

module md5_hash_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] message;
    reg reset;
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
        .reset(reset),
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
            reset = 1;
            start = 0;
            message = 128'b0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: All Zeros...");
            reset_dut();
            test_num = 1;
            message = 128'h00000000000000000000000000000000;
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 128'hed076287532e86365e841e92bfc50d8c);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: All Ones...");
            reset_dut();
            test_num = 2;
            message = 128'hffffffffffffffffffffffffffffffff;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 128'hf849a933f7c9e013f95e26715f3dfd5a);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Sequence Pattern...");
            reset_dut();
            test_num = 3;
            message = 128'h0123456789abcdef0123456789abcdef;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 128'h32d10c7b8cf96570ca04ce37f2a19d84);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Alternating Pattern (A5)...");
            reset_dut();
            test_num = 4;
            message = 128'ha5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 128'h1475c87943d2269e8014522434676678);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Character String Message...");
            reset_dut();
            test_num = 5;

            message = 128'h48656c6c6f20576f726c6421212121;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 128'h9e32a265679905952f41662909405b0d);
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
        $dumpvars(0,clk, message, reset, start, done, hash);
    end

endmodule
