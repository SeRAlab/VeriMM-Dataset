`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg load;
    reg [3:0] parallel_in;
    reg reset;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .enable(enable),
        .load(load),
        .parallel_in(parallel_in),
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
            @(negedge clk);
            reset = 1;
            enable = 0;
            load = 0;
            parallel_in = 0;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase001: Verifying Reset...");
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase002: Verifying Parallel Load...");
            reset_dut();
            @(negedge clk);
            load = 1;
            parallel_in = 4'b1011;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase003: Verifying Single Left Shift...");
            reset_dut();

            @(negedge clk);
            load = 1;
            parallel_in = 4'b0101;
            @(negedge clk);
            load = 0;

            enable = 1;
            @(negedge clk);
            enable = 0;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase004: Verifying Multiple Left Shifts...");
            reset_dut();

            @(negedge clk);
            load = 1;
            parallel_in = 4'b0001;
            @(negedge clk);
            load = 0;

            enable = 1;
            repeat(3) @(negedge clk);
            enable = 0;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase005: Verifying Load Priority over Enable...");
            reset_dut();

            @(negedge clk);
            load = 1;
            parallel_in = 4'b1111;
            @(negedge clk);

            load = 1;
            enable = 1;
            parallel_in = 4'b0110;
            @(negedge clk);
            load = 0;
            enable = 0;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase006: Verifying Enable=0 holds data...");
            reset_dut();
            @(negedge clk);
            load = 1;
            parallel_in = 4'b1001;
            @(negedge clk);
            load = 0;
            enable = 0;
            repeat(3) @(negedge clk);
            #1;

            check_outputs(4'b1001);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase007: Verifying Shift out completely...");
            reset_dut();
            @(negedge clk);
            load = 1;
            parallel_in = 4'b1000;
            @(negedge clk);
            load = 0;
            enable = 1;
            repeat(4) @(negedge clk);
            enable = 0;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [3:0] expected_data_out;
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
        $dumpvars(0,clk, enable, load, parallel_in, reset, data_out);
    end

endmodule
