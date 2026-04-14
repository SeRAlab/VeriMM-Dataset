`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (sequential circuit)
    reg bypass;
    reg clk;
    reg enable;
    reg [15:0] packet_in;
    reg rst;
    wire deny;
    wire [15:0] packet_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .bypass(bypass),
        .clk(clk),
        .enable(enable),
        .packet_in(packet_in),
        .rst(rst),
        .deny(deny),
        .packet_out(packet_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        bypass = 0;
        enable = 0;
        packet_in = 0;
        @(posedge clk);
        #2 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: System Reset Check", test_num);
        reset_dut();

        #1;


        check_outputs(1'b0, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Filter Enabled, Blocked Pattern Match", test_num);
        reset_dut();
        enable = 1;
        bypass = 0;
        packet_in = BLOCKED_PATTERN;
        @(posedge clk);
        #2;

        #1;


        check_outputs(1'b1, 16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Filter Enabled, No Match (Allowed)", test_num);
        reset_dut();
        enable = 1;
        bypass = 0;
        packet_in = 16'h1234;
        @(posedge clk);
        #2;

        #1;


        check_outputs(1'b0, 16'h1234);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Filter Disabled, Blocked Pattern (Allowed)", test_num);
        reset_dut();
        enable = 0;
        bypass = 0;
        packet_in = BLOCKED_PATTERN;
        @(posedge clk);
        #2;

        #1;


        check_outputs(1'b0, BLOCKED_PATTERN);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Bypass Enabled (Overriding Filter)", test_num);
        reset_dut();
        enable = 1;
        bypass = 1;
        packet_in = BLOCKED_PATTERN;
        @(posedge clk);
        #2;

        #1;


        check_outputs(1'b0, BLOCKED_PATTERN);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Dynamic Filter Toggle", test_num);
        reset_dut();


        enable = 1;
        packet_in = BLOCKED_PATTERN;
        @(posedge clk);
        #2;


        enable = 0;
        @(posedge clk);
        #2;

        #1;


        check_outputs(1'b0, BLOCKED_PATTERN);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("packet_filter Testbench");
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
        input expected_deny;
        input [15:0] expected_packet_out;
        begin
            if (expected_deny === (expected_deny ^ deny ^ expected_deny) &&
                expected_packet_out === (expected_packet_out ^ packet_out ^ expected_packet_out)) begin
                $display("PASS");
                $display("  Outputs: deny=%b, packet_out=%h",
                         deny, packet_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: deny=%b, packet_out=%h",
                         expected_deny, expected_packet_out);
                $display("  Got:      deny=%b, packet_out=%h",
                         deny, packet_out);
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
        $dumpvars(0,bypass, clk, enable, packet_in, rst, deny, packet_out);
    end

endmodule
