`timescale 1ns/1ps

module sha256_pad_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] msg_in;
    reg rst;
    wire [511:0] padded_msg_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sha256_pad dut (
        .clk(clk),
        .msg_in(msg_in),
        .rst(rst),
        .padded_msg_out(padded_msg_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            msg_in = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset Check...");
            rst = 1;
            msg_in = 512'hFFFF_FFFF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(512'h0);
            reset_dut();
        end
        endtask

    task testcase002;

        reg [511:0] expected;
        begin
            $display("Running testcase002: All Zeros Input...");
            reset_dut();
            msg_in = 512'h0;
            expected = {8'h80, 440'h0, 64'h200};
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase003;

        reg [511:0] expected;
        begin
            $display("Running testcase003: All Ones Input...");
            reset_dut();
            msg_in = {16{32'hFFFF_FFFF}};
            expected = {8'h80, 440'h0, 64'h200};
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase004;

        reg [511:0] expected;
        begin
            $display("Running testcase004: Alternating Bit Pattern...");
            reset_dut();
            msg_in = {64{8'hAA}};
            expected = {8'h80, 440'h0, 64'h200};
            #1;

            check_outputs(expected);
        end
        endtask

    task testcase005;

        reg [511:0] expected;
        begin
            $display("Running testcase005: Hex Pattern...");
            reset_dut();
            msg_in = 512'h0123456789ABCDEF_FEDCBA9876543210_0123456789ABCDEF_FEDCBA9876543210_0123456789ABCDEF_FEDCBA9876543210_0123456789ABCDEF_FEDCBA9876543210;
            expected = {8'h80, 440'h0, 64'h200};
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
        $display("sha256_pad Testbench");
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
        input [511:0] expected_padded_msg_out;
        begin
            if (expected_padded_msg_out === (expected_padded_msg_out ^ padded_msg_out ^ expected_padded_msg_out)) begin
                $display("PASS");
                $display("  Outputs: padded_msg_out=%h",
                         padded_msg_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: padded_msg_out=%h",
                         expected_padded_msg_out);
                $display("  Got:      padded_msg_out=%h",
                         padded_msg_out);
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
        $dumpvars(0,clk, msg_in, rst, padded_msg_out);
    end

endmodule
