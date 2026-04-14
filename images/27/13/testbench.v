`timescale 1ns/1ps

module LRU_Cache_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] address;
    reg clk;
    reg [7:0] data_in;
    reg reset;
    wire [7:0] data_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LRU_Cache dut (
        .address(address),
        .clk(clk),
        .data_in(data_in),
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
            address = 0;
            data_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Hit...");
            reset_dut();
            test_num = 1;

            address = 4'h1; data_in = 8'hAA;
            @(posedge clk); #1;

            address = 4'h1;
            @(posedge clk); #1;
            #1;

            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: LRU Eviction...");
            reset_dut();
            test_num = 2;

            address = 4'h1; data_in = 8'h11; @(posedge clk); #1;
            address = 4'h2; data_in = 8'h22; @(posedge clk); #1;
            address = 4'h3; data_in = 8'h33; @(posedge clk); #1;
            address = 4'h4; data_in = 8'h44; @(posedge clk); #1;

            address = 4'h5; data_in = 8'h55; @(posedge clk); #1;

            address = 4'h1;
            @(posedge clk); #1;
            #1;

            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: LRU Re-ordering Hit...");
            reset_dut();
            test_num = 3;

            address = 4'h1; data_in = 8'h11; @(posedge clk); #1;
            address = 4'h2; data_in = 8'h22; @(posedge clk); #1;
            address = 4'h3; data_in = 8'h33; @(posedge clk); #1;
            address = 4'h4; data_in = 8'h44; @(posedge clk); #1;

            address = 4'h1; @(posedge clk); #1;

            address = 4'h5; data_in = 8'h55; @(posedge clk); #1;

            address = 4'h1;
            @(posedge clk); #1;
            #1;

            check_outputs(8'h11, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Confirming Eviction of Addr 2...");
            reset_dut();
            test_num = 4;

            address = 4'h1; data_in = 8'h11; @(posedge clk); #1;
            address = 4'h2; data_in = 8'h22; @(posedge clk); #1;
            address = 4'h3; data_in = 8'h33; @(posedge clk); #1;
            address = 4'h4; data_in = 8'h44; @(posedge clk); #1;
            address = 4'h1; @(posedge clk); #1;
            address = 4'h5; data_in = 8'h55; @(posedge clk); #1;

            address = 4'h2;
            @(posedge clk); #1;
            #1;

            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Reset Verification...");
            reset_dut();
            test_num = 5;

            address = 4'hA; data_in = 8'hAA; @(posedge clk); #1;

            reset = 1; @(posedge clk); #1; reset = 0; @(posedge clk); #1;

            address = 4'hA;
            @(posedge clk); #1;
            #1;

            check_outputs(8'h00, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LRU_Cache Testbench");
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
        input [7:0] expected_data_out;
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
        $dumpvars(0,address, clk, data_in, reset, data_out, valid);
    end

endmodule
