`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg enable;
    reg parallel_load;
    reg reset;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .parallel_load(parallel_load),
        .reset(reset),
        .data_out(data_out)
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
            parallel_load = 0;
            data_in = 0;
            sync_step();
            reset = 0;
            sync_step();
        end
        endtask
    task sync_step;

        begin
            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset verification", test_num);
            reset_dut();
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Parallel load with MSB=1", test_num);
            reset_dut();
            parallel_load = 1;
            data_in = 32'h8000_0000;
            sync_step();
            parallel_load = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Parallel load with MSB=0", test_num);
            reset_dut();
            parallel_load = 1;
            data_in = 32'h7FFF_FFFF;
            sync_step();
            parallel_load = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift MSB to LSB", test_num);
            reset_dut();

            parallel_load = 1;
            data_in = 32'h8000_0000;
            sync_step();

            parallel_load = 0;
            enable = 1;
            sync_step();
            enable = 0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full 32-bit rotation", test_num);
            reset_dut();
            parallel_load = 1;
            data_in = 32'h8000_0000;
            sync_step();
            parallel_load = 0;
            enable = 1;

            for (i = 0; i < 32; i = i + 1) begin
                sync_step();
            end
            enable = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rotate LSB to MSB (31 shifts)", test_num);
            reset_dut();
            parallel_load = 1;
            data_in = 32'h0000_0001;
            sync_step();
            parallel_load = 0;
            enable = 1;

            for (i = 0; i < 31; i = i + 1) begin
                sync_step();
            end
            enable = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset priority over Load", test_num);
            reset_dut();
            reset = 1;
            parallel_load = 1;
            data_in = 32'hFFFF_FFFF;
            sync_step();
            reset = 0;
            parallel_load = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load priority over Enable", test_num);
            reset_dut();

            parallel_load = 1;
            enable = 1;
            data_in = 32'h8000_0000;
            sync_step();
            parallel_load = 0;
            enable = 0;
            #1;

            check_outputs(1'b1);
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
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b",
                         expected_data_out);
                $display("  Got:      data_out=%b",
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
        $dumpvars(0,clk, data_in, enable, parallel_load, reset, data_out);
    end

endmodule
