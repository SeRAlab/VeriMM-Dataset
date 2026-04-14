`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] data_in;
    reg data_in_valid;
    reg sync_n;
    reg sysclk;
    wire [31:0] data_out;
    wire data_out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .data_in_valid(data_in_valid),
        .sync_n(sync_n),
        .sysclk(sysclk),
        .data_out(data_out),
        .data_out_valid(data_out_valid)
    );

    // Clock generation (10ns period)
    initial begin
        sysclk = 0;
        forever #5 sysclk = ~sysclk;
    end

        task reset_dut;

    begin
        sync_n = 0;
        data_in = 8'h0;
        data_in_valid = 0;
        repeat(2) @(posedge sysclk);
        #1;
        sync_n = 1;
        @(posedge sysclk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: Basic 4-byte packing", test_num);
        reset_dut();


        data_in_valid = 1;
        data_in = 8'h11; @(posedge sysclk); #1;
        data_in = 8'h22; @(posedge sysclk); #1;
        data_in = 8'h33; @(posedge sysclk); #1;
        data_in = 8'h44; @(posedge sysclk); #1;

        data_in_valid = 0;
        #1;

        check_outputs(32'h11223344, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: Intermittent valid signal", test_num);
        reset_dut();

        data_in_valid = 1; data_in = 8'hAA; @(posedge sysclk); #1;
        data_in_valid = 0; data_in = 8'hFF; @(posedge sysclk); #1;
        data_in_valid = 1; data_in = 8'hBB; @(posedge sysclk); #1;
        data_in_valid = 0; data_in = 8'hEE; @(posedge sysclk); #1;
        data_in_valid = 1; data_in = 8'hCC; @(posedge sysclk); #1;
        data_in_valid = 1; data_in = 8'hDD; @(posedge sysclk); #1;

        data_in_valid = 0;
        #1;

        check_outputs(32'hAABBCCDD, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: Sync reset mid-operation", test_num);
        reset_dut();


        data_in_valid = 1;
        data_in = 8'h01; @(posedge sysclk); #1;
        data_in = 8'h02; @(posedge sysclk); #1;


        sync_n = 0; @(posedge sysclk); #1;
        sync_n = 1;


        data_in = 8'h55; @(posedge sysclk); #1;
        data_in = 8'h66; @(posedge sysclk); #1;
        data_in = 8'h77; @(posedge sysclk); #1;
        data_in = 8'h88; @(posedge sysclk); #1;

        data_in_valid = 0;
        #1;

        check_outputs(32'h55667788, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: Back-to-back packing", test_num);
        reset_dut();


        data_in_valid = 1;
        data_in = 8'hDE; @(posedge sysclk); #1;
        data_in = 8'hAD; @(posedge sysclk); #1;
        data_in = 8'hBE; @(posedge sysclk); #1;
        data_in = 8'hEF; @(posedge sysclk); #1;


        if (data_out_valid !== 1 || data_out !== 32'hDEADBEEF) begin
            $display("Sub-test Failed: First word not packed correctly");
        end


        data_in = 8'hCA; @(posedge sysclk); #1;
        data_in = 8'hFE; @(posedge sysclk); #1;
        data_in = 8'hBA; @(posedge sysclk); #1;
        data_in = 8'hBE; @(posedge sysclk); #1;

        data_in_valid = 0;
        #1;

        check_outputs(32'hCAFEBABE, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: Boundary data patterns", test_num);
        reset_dut();

        data_in_valid = 1;
        data_in = 8'hFF; @(posedge sysclk); #1;
        data_in = 8'h00; @(posedge sysclk); #1;
        data_in = 8'hFF; @(posedge sysclk); #1;
        data_in = 8'h00; @(posedge sysclk); #1;

        data_in_valid = 0;
        #1;

        check_outputs(32'hFF00FF00, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_data_out_valid;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_data_out_valid === (expected_data_out_valid ^ data_out_valid ^ expected_data_out_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, data_out_valid=%b",
                         data_out, data_out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, data_out_valid=%b",
                         expected_data_out, expected_data_out_valid);
                $display("  Got:      data_out=%h, data_out_valid=%b",
                         data_out, data_out_valid);
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
        $dumpvars(0,data_in, data_in_valid, sync_n, sysclk, data_out, data_out_valid);
    end

endmodule
