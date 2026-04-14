`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg shift_dir;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .shift_dir(shift_dir),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        integer i;
        begin
            @(negedge clk);
            data_in = 0;
            shift_dir = 0;
            for (i = 0; i < 16; i = i + 1) begin
                @(negedge clk);
            end
        end
        endtask
    task testcase001;

        integer i;
        reg [15:0] pattern;
        begin
            test_num = 1;
            $display("Running Testcase %03d: Full 16-bit Left Shift", test_num);
            reset_dut();
            pattern = 16'hA5A5;
            shift_dir = 0;
            for (i = 0; i < 16; i = i + 1) begin
                data_in = pattern[15-i];
                @(negedge clk);
            end
            #1;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase002;

        integer i;
        reg [15:0] pattern;
        begin
            test_num = 2;
            $display("Running Testcase %03d: Full 16-bit Right Shift", test_num);
            reset_dut();
            pattern = 16'h5A5A;
            shift_dir = 1;
            for (i = 0; i < 16; i = i + 1) begin
                data_in = pattern[i];
                @(negedge clk);
            end
            #1;
            #1;

            check_outputs(16'h5A5A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %03d: Partial Left Shift", test_num);
            reset_dut();
            shift_dir = 0;

            data_in = 1; @(negedge clk);
            data_in = 1; @(negedge clk);
            data_in = 0; @(negedge clk);
            data_in = 1; @(negedge clk);
            #1;
            #1;

            check_outputs(16'h000D);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %03d: Partial Right Shift", test_num);
            reset_dut();
            shift_dir = 1;

            data_in = 1; @(negedge clk);
            data_in = 1; @(negedge clk);
            data_in = 0; @(negedge clk);
            data_in = 1; @(negedge clk);
            #1;


            #1;



            check_outputs(16'hB000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %03d: Direction Switch Test", test_num);
            reset_dut();

            shift_dir = 0;
            data_in = 1;
            repeat(16) @(negedge clk);

            shift_dir = 1;
            data_in = 0;
            repeat(4) @(negedge clk);
            #1;

            #1;


            check_outputs(16'h0FFF);
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, shift_dir, data_out);
    end

endmodule
