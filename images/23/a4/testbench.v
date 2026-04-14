`timescale 1ns/1ps

module HMAC_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] key;
    reg [63:0] message;
    reg rst;
    wire [63:0] mac;

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
        .mac(mac)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            key = 0;
            message = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            key = 64'h0000000000000000;
            message = 64'h0000000000000000;
            @(posedge clk);
            #2 #1;
 check_outputs((key ^ message) & HMAC_MASK);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            key = 64'hFFFFFFFFFFFFFFFF;
            message = 64'h0000000000000000;
            @(posedge clk);
            #2 #1;
 check_outputs((key ^ message) & HMAC_MASK);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            key = 64'h0000000000000000;
            message = 64'hFFFFFFFFFFFFFFFF;
            @(posedge clk);
            #2 #1;
 check_outputs((key ^ message) & HMAC_MASK);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            key = 64'hA5A5A5A5A5A5A5A5;
            message = 64'hA5A5A5A5A5A5A5A5;
            @(posedge clk);
            #2 #1;
 check_outputs((key ^ message) & HMAC_MASK);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            key = 64'h5555555555555555;
            message = 64'hAAAAAAAAAAAAAAAA;
            @(posedge clk);
            #2 #1;
 check_outputs((key ^ message) & HMAC_MASK);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            key = 64'h123456789ABCDEF0;
            message = 64'hFEDCBA9876543210;
            @(posedge clk);
            #2 #1;
 check_outputs((key ^ message) & HMAC_MASK);
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
        input [63:0] expected_mac;
        begin
            if (expected_mac === (expected_mac ^ mac ^ expected_mac)) begin
                $display("PASS");
                $display("  Outputs: mac=%h",
                         mac);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mac=%h",
                         expected_mac);
                $display("  Got:      mac=%h",
                         mac);
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
        $dumpvars(0,clk, key, message, rst, mac);
    end

endmodule
