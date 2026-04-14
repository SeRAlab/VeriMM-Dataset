`timescale 1ns/1ps

module SISO_Shift_Register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg reset;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SISO_Shift_Register dut (
        .clk(clk),
        .data_in(data_in),
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
            $display("Running testcase001: Shift 1 followed by 0, 0, 0");
            reset_dut();
            test_num = 1;
            data_in = 1; @(posedge clk); #1;
            data_in = 0; @(posedge clk); #1;
            data_in = 0; @(posedge clk); #1;
            data_in = 0; @(posedge clk); #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Shift 0 followed by 1, 1, 1");
            reset_dut();
            test_num = 2;
            data_in = 0; @(posedge clk); #1;
            data_in = 1; @(posedge clk); #1;
            data_in = 1; @(posedge clk); #1;
            data_in = 1; @(posedge clk); #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Shift four 1s");
            reset_dut();
            test_num = 3;
            data_in = 1; @(posedge clk); #1;
            data_in = 1; @(posedge clk); #1;
            data_in = 1; @(posedge clk); #1;
            data_in = 1; @(posedge clk); #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Shift four 0s");
            reset_dut();
            test_num = 4;
            data_in = 0; @(posedge clk); #1;
            data_in = 0; @(posedge clk); #1;
            data_in = 0; @(posedge clk); #1;
            data_in = 0; @(posedge clk); #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Pattern 1, 0, 1, 0");
            reset_dut();
            test_num = 5;
            data_in = 1; @(posedge clk); #1;
            data_in = 0; @(posedge clk); #1;
            data_in = 1; @(posedge clk); #1;
            data_in = 0; @(posedge clk); #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Pattern 0, 1, 0, 1");
            reset_dut();
            test_num = 6;
            data_in = 0; @(posedge clk); #1;
            data_in = 1; @(posedge clk); #1;
            data_in = 0; @(posedge clk); #1;
            data_in = 1; @(posedge clk); #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Shift 5 bits (1, 0, 0, 0, 0)");
            reset_dut();
            test_num = 7;
            data_in = 1; @(posedge clk); #1;
            data_in = 0; @(posedge clk); #1;
            data_in = 0; @(posedge clk); #1;
            data_in = 0; @(posedge clk); #1;
            data_in = 0; @(posedge clk); #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Shift 5 bits (0, 1, 1, 1, 1)");
            reset_dut();
            test_num = 8;
            data_in = 0; @(posedge clk); #1;
            data_in = 1; @(posedge clk); #1;
            data_in = 1; @(posedge clk); #1;
            data_in = 1; @(posedge clk); #1;
            data_in = 1; @(posedge clk); #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase009;

        begin
            $display("Running testcase009: Shift data then reset mid-operation");
            reset_dut();
            test_num = 9;
            data_in = 1; @(posedge clk); #1;
            data_in = 1; @(posedge clk); #1;
            reset = 1;   @(posedge clk); #1;
            reset = 0;
            data_in = 0; @(posedge clk); #1;
            data_in = 0; @(posedge clk); #1;
            #1;

            check_outputs(0);
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
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        $dumpvars(0,clk, data_in, reset, data_out);
    end

endmodule
