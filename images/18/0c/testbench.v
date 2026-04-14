`timescale 1ns/1ps

module hmac_generator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] key;
    reg [127:0] message;
    reg reset;
    wire [127:0] hash_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hmac_generator dut (
        .clk(clk),
        .key(key),
        .message(message),
        .reset(reset),
        .hash_output(hash_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            key = 128'h0;
            message = 128'h0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: All Zeros", test_num);
            reset_dut();
            key = 128'h0;
            message = 128'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(128'h0 ^ 128'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: All Ones", test_num);
            reset_dut();
            key = {128{1'b1}};
            message = {128{1'b1}};
            @(posedge clk);
            #1;
            #1;

            check_outputs(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF ^ 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Key with Zero Message", test_num);
            reset_dut();
            key = 128'h0123456789ABCDEF0123456789ABCDEF;
            message = 128'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(128'h0123456789ABCDEF0123456789ABCDEF ^ 128'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Alternating Bit Patterns (55/AA)", test_num);
            reset_dut();
            key = 128'h55555555555555555555555555555555;
            message = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(128'h55555555555555555555555555555555 ^ 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Arbitrary Hex Values", test_num);
            reset_dut();
            key = 128'hDEADBEEFCAFEBABE1234567887654321;
            message = 128'hFEEDFACEDEADBEEFCAFED00D00000001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(128'hDEADBEEFCAFEBABE1234567887654321 ^ 128'hFEEDFACEDEADBEEFCAFED00D00000001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hmac_generator Testbench");
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
        input [127:0] expected_hash_output;
        begin
            if (expected_hash_output === (expected_hash_output ^ hash_output ^ expected_hash_output)) begin
                $display("PASS");
                $display("  Outputs: hash_output=%h",
                         hash_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash_output=%h",
                         expected_hash_output);
                $display("  Got:      hash_output=%h",
                         hash_output);
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
        $dumpvars(0,clk, key, message, reset, hash_output);
    end

endmodule
