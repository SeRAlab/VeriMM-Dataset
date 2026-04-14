`timescale 1ns/1ps

module pcie_interface_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg data_valid;
    reg reset;
    wire [31:0] data_out;
    wire data_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_interface dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .reset(reset),
        .data_out(data_out),
        .data_ready(data_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;
            reset = 1;
            data_in = 32'h0;
            data_valid = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Basic Data Transfer (0xDEADBEEF)");
            reset_dut();


            data_in = 32'hDEADBEEF;
            data_valid = 1;
            @(posedge clk);
            #1;
            data_valid = 0;
            data_in = 32'h0;


            repeat (DELAY_VAL) @(posedge clk);
            #1;

            #1;


            check_outputs(32'hDEADBEEF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Basic Data Transfer (0x12345678)");
            reset_dut();

            data_in = 32'h12345678;
            data_valid = 1;
            @(posedge clk);
            #1;
            data_valid = 0;

            repeat (DELAY_VAL) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h12345678, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Check Reset State");
            reset_dut();


            repeat (DELAY_VAL) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: data_in change without data_valid");
            reset_dut();

            data_in = 32'hAAAA5555;
            data_valid = 0;
            @(posedge clk);
            #1;

            repeat (DELAY_VAL) @(posedge clk);
            #1;


            #1;



            check_outputs(32'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Max Value Transfer (0xFFFFFFFF)");
            reset_dut();

            data_in = 32'hFFFFFFFF;
            data_valid = 1;
            @(posedge clk);
            #1;
            data_valid = 0;

            repeat (DELAY_VAL) @(posedge clk);
            #1;

            #1;


            check_outputs(32'hFFFFFFFF, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_interface Testbench");
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
        input expected_data_ready;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_data_ready === (expected_data_ready ^ data_ready ^ expected_data_ready)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, data_ready=%b",
                         data_out, data_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, data_ready=%b",
                         expected_data_out, expected_data_ready);
                $display("  Got:      data_out=%h, data_ready=%b",
                         data_out, data_ready);
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
        $dumpvars(0,clk, data_in, data_valid, reset, data_out, data_ready);
    end

endmodule
