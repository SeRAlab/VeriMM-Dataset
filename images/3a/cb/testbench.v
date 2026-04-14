`timescale 1ns/1ps

module HMAC_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] key;
    reg [63:0] message;
    reg rst;
    wire [63:0] tag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    HMAC dut (
        .clk(clk),
        .key(key),
        .message(message),
        .rst(rst),
        .tag(tag)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            key = 64'h0;
            message = 64'h0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task calculate_expected;

        begin
            calc_temp = (key ^ message) << 1;
            expected_tag_val = calc_temp % 64'hFFFFFFFFFFFFFFFF;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: All Zeros...", test_num);
            reset_dut();
            key = 64'h0;
            message = 64'h0;
            calculate_expected();
            @(posedge clk);
            #1 #1;
 check_outputs(expected_tag_val);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Max Key...", test_num);
            reset_dut();
            key = 64'hFFFFFFFFFFFFFFFF;
            message = 64'h0;
            calculate_expected();
            @(posedge clk);
            #1 #1;
 check_outputs(expected_tag_val);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Alternating Bits...", test_num);
            reset_dut();
            key = 64'hAAAAAAAAAAAAAAAA;
            message = 64'h5555555555555555;
            calculate_expected();
            @(posedge clk);
            #1 #1;
 check_outputs(expected_tag_val);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Key matches Message...", test_num);
            reset_dut();
            key = 64'h123456789ABCDEF0;
            message = 64'h123456789ABCDEF0;
            calculate_expected();
            @(posedge clk);
            #1 #1;
 check_outputs(expected_tag_val);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Random Hex Values...", test_num);
            reset_dut();
            key = 64'hDEADBEEFCAFEBABE;
            message = 64'h876543210FEDCBA9;
            calculate_expected();
            @(posedge clk);
            #1 #1;
 check_outputs(expected_tag_val);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("HMAC Testbench");
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
        input [63:0] expected_tag;
        begin
            if (expected_tag === (expected_tag ^ tag ^ expected_tag)) begin
                $display("PASS");
                $display("  Outputs: tag=%h",
                         tag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tag=%h",
                         expected_tag);
                $display("  Got:      tag=%h",
                         tag);
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
        $dumpvars(0,clk, key, message, rst, tag);
    end

endmodule
