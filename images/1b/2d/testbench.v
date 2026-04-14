`timescale 1ns/1ps

module PIPO_Shift_Register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [7:0] parallel_in;
    wire [7:0] parallel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PIPO_Shift_Register dut (
        .clk(clk),
        .load(load),
        .parallel_in(parallel_in),
        .parallel_out(parallel_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("\nResetting Register (Loading 0x00)...");
            @(negedge clk);
            load = 1;
            parallel_in = 8'h00;
            @(negedge clk);
            load = 0;
            parallel_in = 8'h00;

            if (parallel_out !== 8'h00) begin
                $display("Reset Failed!");
            end
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic Parallel Load (0xA5)", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            parallel_in = 8'hA5;
            @(negedge clk);
            load = 0;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Shift Right Once", test_num);
            reset_dut();


            @(negedge clk);
            load = 1;
            parallel_in = 8'hFF;
            @(negedge clk);


            load = 0;
            @(negedge clk);

            #1;


            check_outputs(8'h7F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Shift Right 4 Times", test_num);
            reset_dut();


            @(negedge clk);
            load = 1;
            parallel_in = 8'h80;
            @(negedge clk);


            load = 0;
            repeat(4) @(negedge clk);

            #1;


            check_outputs(8'h08);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Shift LSB out of register", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            parallel_in = 8'h01;
            @(negedge clk);

            load = 0;
            @(negedge clk);

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Shift with parallel_in changing (ignored)", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            parallel_in = 8'hAA;
            @(negedge clk);

            load = 0;
            parallel_in = 8'hFF;
            repeat(2) @(negedge clk);

            #1;


            check_outputs(8'h2A);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PIPO_Shift_Register Testbench");
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
        input [7:0] expected_parallel_out;
        begin
            if (expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out)) begin
                $display("PASS");
                $display("  Outputs: parallel_out=%h",
                         parallel_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parallel_out=%h",
                         expected_parallel_out);
                $display("  Got:      parallel_out=%h",
                         parallel_out);
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
        $dumpvars(0,clk, load, parallel_in, parallel_out);
    end

endmodule
