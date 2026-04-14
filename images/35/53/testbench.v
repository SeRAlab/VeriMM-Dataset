`timescale 1ns/1ps

module simple_des_encryption_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] data_in;
    reg [63:0] key;
    wire [63:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_des_encryption dut (
        .clk(clk),
        .data_in(data_in),
        .key(key),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in = 64'h0;
            key = 64'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: All Zeros");
            reset_dut();
            data_in = 64'h0000000000000000;
            key     = 64'h0000000000000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: XOR with All Ones");
            reset_dut();
            data_in = 64'hAAAA_AAAA_AAAA_AAAA;
            key     = 64'hFFFF_FFFF_FFFF_FFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h5555_5555_5555_5555);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Identity Check (Key=0)");
            reset_dut();
            data_in = 64'h1234_5678_9ABC_DEF0;
            key     = 64'h0000_0000_0000_0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h1234_5678_9ABC_DEF0);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Byte-wise unique patterns");
            reset_dut();


            data_in = 64'h0102_0304_0506_0708;
            key     = 64'h1020_3040_5060_7080;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h1122_3344_5566_7788);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Symmetric XOR");
            reset_dut();
            data_in = 64'hFEDC_BA98_7654_3210;
            key     = 64'hFEDC_BA98_7654_3210;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h0000_0000_0000_0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_des_encryption Testbench");
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
        input [63:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, key, data_out);
    end

endmodule
