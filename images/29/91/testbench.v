`timescale 1ns/1ps

module deserializer_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg enable;
    reg reset;
    wire [31:0] data_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer_32bit dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .reset(reset),
        .data_out(data_out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            data_in = 8'h0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Test Case %0d: Basic 4-byte conversion", test_num);
            reset_dut();

            enable = 1;
            data_in = 8'h12; @(posedge clk); #1;
            data_in = 8'h34; @(posedge clk); #1;
            data_in = 8'h56; @(posedge clk); #1;
            data_in = 8'h78; @(posedge clk); #1;

            enable = 0;
            #1;

            check_outputs(32'h12345678, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Test Case %0d: Enable gating", test_num);
            reset_dut();

            enable = 1;
            data_in = 8'hAA; @(posedge clk); #1;
            enable = 0;
            data_in = 8'hFF; @(posedge clk); #1;
            enable = 1;
            data_in = 8'hBB; @(posedge clk); #1;
            data_in = 8'hCC; @(posedge clk); #1;
            data_in = 8'hDD; @(posedge clk); #1;

            enable = 0;
            #1;

            check_outputs(32'hAABBCCDD, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Test Case %0d: Mid-transfer reset", test_num);
            reset_dut();

            enable = 1;
            data_in = 8'h11; @(posedge clk); #1;
            data_in = 8'h22; @(posedge clk); #1;

            reset = 1; @(posedge clk); #1;
            reset = 0;

            data_in = 8'h55; @(posedge clk); #1;
            data_in = 8'h66; @(posedge clk); #1;
            data_in = 8'h77; @(posedge clk); #1;
            data_in = 8'h88; @(posedge clk); #1;

            enable = 0;
            #1;

            check_outputs(32'h55667788, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Test Case %0d: Incomplete transfer (3 bytes)", test_num);
            reset_dut();

            enable = 1;
            data_in = 8'hDE; @(posedge clk); #1;
            data_in = 8'hAD; @(posedge clk); #1;
            data_in = 8'hBE; @(posedge clk); #1;

            enable = 0;

            #1;


            check_outputs(data_out, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Test Case %0d: Back-to-back transfers", test_num);
            reset_dut();

            enable = 1;

            data_in = 8'h01; @(posedge clk); #1;
            data_in = 8'h02; @(posedge clk); #1;
            data_in = 8'h03; @(posedge clk); #1;
            data_in = 8'h04; @(posedge clk); #1;

            data_in = 8'h05; @(posedge clk); #1;
            data_in = 8'h06; @(posedge clk); #1;
            data_in = 8'h07; @(posedge clk); #1;
            data_in = 8'h08; @(posedge clk); #1;

            enable = 0;
            #1;

            check_outputs(32'h05060708, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deserializer_32bit Testbench");
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
        input [31:0] expected_data_out;
        input expected_valid;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid=%b",
                         data_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid=%b",
                         expected_data_out, expected_valid);
                $display("  Got:      data_out=%h, valid=%b",
                         data_out, valid);
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
        $dumpvars(0,clk, data_in, enable, reset, data_out, valid);
    end

endmodule
