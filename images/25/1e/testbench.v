`timescale 1ns/1ps

module chacha20_stream_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] key;
    reg [31:0] nonce;
    wire [31:0] stream_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha20_stream dut (
        .clk(clk),
        .key(key),
        .nonce(nonce),
        .stream_output(stream_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            key <= 32'h0;
            nonce <= 32'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            reset_dut();
            key <= 32'h00000000;
            nonce <= 32'h00000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000 ^ 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Alternating Bits", test_num);
            reset_dut();
            key <= 32'hAAAAAAAA;
            nonce <= 32'h55555555;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hAAAAAAAA ^ 32'h55555555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Identical Inputs", test_num);
            reset_dut();
            key <= 32'hFFFFFFFF;
            nonce <= 32'hFFFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF ^ 32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Arbitrary Hex Values", test_num);
            reset_dut();
            key <= 32'h12345678;
            nonce <= 32'h87654321;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12345678 ^ 32'h87654321);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Key with Zero Nonce", test_num);
            reset_dut();
            key <= 32'hDEADBEEF;
            nonce <= 32'h00000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF ^ 32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Nonce with Zero Key", test_num);
            reset_dut();
            key <= 32'h00000000;
            nonce <= 32'hC0DEFEED;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000 ^ 32'hC0DEFEED);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha20_stream Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [31:0] expected_stream_output;
        begin
            if (expected_stream_output === (expected_stream_output ^ stream_output ^ expected_stream_output)) begin
                $display("PASS");
                $display("  Outputs: stream_output=%h",
                         stream_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stream_output=%h",
                         expected_stream_output);
                $display("  Got:      stream_output=%h",
                         stream_output);
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
        $dumpvars(0,clk, key, nonce, stream_output);
    end

endmodule
