`timescale 1ns/1ps

module SISO_Shift_Register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SISO_Shift_Register dut (
        .clk(clk),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Resetting/Clearing Register", test_num);
            data_in = 0;
            repeat(4) @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase %03d: Shifting sequence 1-0-0-0", test_num);
            @(negedge clk) data_in = 1;
            @(negedge clk) data_in = 0;
            @(negedge clk) data_in = 0;
            @(negedge clk) data_in = 0;
            @(negedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase %03d: Shifting sequence 0-1-1-1", test_num);
            @(negedge clk) data_in = 0;
            @(negedge clk) data_in = 1;
            @(negedge clk) data_in = 1;
            @(negedge clk) data_in = 1;
            @(negedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase %03d: Shifting sequence 1-1-1-1", test_num);
            @(negedge clk) data_in = 1;
            @(negedge clk) data_in = 1;
            @(negedge clk) data_in = 1;
            @(negedge clk) data_in = 1;
            @(negedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase %03d: Shifting sequence 1-0-1-0", test_num);
            @(negedge clk) data_in = 1;
            @(negedge clk) data_in = 0;
            @(negedge clk) data_in = 1;
            @(negedge clk) data_in = 0;
            @(negedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase %03d: Checking second bit of 1-0-1-1 stream", test_num);
            @(negedge clk) data_in = 1;
            @(negedge clk) data_in = 0;
            @(negedge clk) data_in = 1;
            @(negedge clk) data_in = 1;
            @(negedge clk) data_in = 0;
            @(negedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SISO_Shift_Register Testbench");
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
        $dumpvars(0,clk, data_in, data_out);
    end

endmodule
