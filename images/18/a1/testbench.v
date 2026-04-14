`timescale 1ns/1ps

module hmac_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] key;
    reg [127:0] message;
    reg reset;
    wire [127:0] hmac_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hmac dut (
        .clk(clk),
        .key(key),
        .message(message),
        .reset(reset),
        .hmac_out(hmac_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            key = 128'b0;
            message = 128'b0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        reg [127:0] expected;
        begin
            $display("\nRunning testcase001: All Zeros...");
            reset_dut();
            test_num = test_num + 1;
            key = 128'h0;
            message = 128'h0;
            expected = calculate_expected(key, message);
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase002;

        reg [127:0] expected;
        begin
            $display("\nRunning testcase002: All Ones...");
            reset_dut();
            test_num = test_num + 1;
            key = {4{32'hFFFFFFFF}};
            message = {4{32'hFFFFFFFF}};
            expected = calculate_expected(key, message);
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase003;

        reg [127:0] expected;
        begin
            $display("\nRunning testcase003: Alternating Patterns...");
            reset_dut();
            test_num = test_num + 1;
            key = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            message = 128'h55555555555555555555555555555555;
            expected = calculate_expected(key, message);
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase004;

        reg [127:0] expected;
        begin
            $display("\nRunning testcase004: Specific Hex Values...");
            reset_dut();
            test_num = test_num + 1;
            key = 128'hDEADBEEFCAFEBABE1234567887654321;
            message = 128'h0123456789ABCDEFDEADBEEFCAFEBABE;
            expected = calculate_expected(key, message);
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase005;

        reg [127:0] expected;
        begin
            $display("\nRunning testcase005: Change Message, Constant Key...");
            reset_dut();
            test_num = test_num + 1;
            key = 128'hFEDCBA9876543210FEDCBA9876543210;
            message = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            expected = calculate_expected(key, message);
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase006;

        reg [127:0] expected;
        begin
            $display("\nRunning testcase006: Change Key, Constant Message...");
            reset_dut();
            test_num = test_num + 1;
            key = 128'h13579BDF02468ACE13579BDF02468ACE;
            message = 128'hFEDCBA9876543210FEDCBA9876543210;
            expected = calculate_expected(key, message);
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(expected);
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
        input [127:0] expected_hmac_out;
        begin
            if (expected_hmac_out === (expected_hmac_out ^ hmac_out ^ expected_hmac_out)) begin
                $display("PASS");
                $display("  Outputs: hmac_out=%h",
                         hmac_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hmac_out=%h",
                         expected_hmac_out);
                $display("  Got:      hmac_out=%h",
                         hmac_out);
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
        $dumpvars(0,clk, key, message, reset, hmac_out);
    end

endmodule
