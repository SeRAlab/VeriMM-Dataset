`timescale 1ns/1ps

module lfsr_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    wire [3:0] lfsr_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .lfsr_out(lfsr_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            enable = 0;
            @(posedge clk);
            #1;
            reset = 0;
            $display("Reset complete.");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(4'h1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Shift (1 cycle)", test_num);
            reset_dut();
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;

            #1;


            check_outputs(4'h2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Multiple Shifts (3 cycles)", test_num);
            reset_dut();
            enable = 1;
            repeat(3) @(posedge clk);
            #1;
            enable = 0;




            #1;





            check_outputs(4'h9);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Enable Control (Hold)", test_num);
            reset_dut();
            enable = 1;
            repeat(3) @(posedge clk);
            #1;
            enable = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h9);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Mid-sequence transition", test_num);
            reset_dut();
            enable = 1;
            repeat(7) @(posedge clk);
            #1;
            enable = 0;




            #1;





            check_outputs(4'hA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Full sequence wrap-around (15 cycles)", test_num);
            reset_dut();
            enable = 1;
            repeat(15) @(posedge clk);
            #1;
            enable = 0;


            #1;



            check_outputs(4'h1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Toggling Enable Mid-Stream", test_num);
            reset_dut();
            enable = 1;
            repeat(2) @(posedge clk);
            #1;
            enable = 0;
            @(posedge clk);
            #1;
            enable = 1;
            @(posedge clk);
            #1;
            enable = 0;
            #1;

            check_outputs(4'h9);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lfsr Testbench");
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
        input [3:0] expected_lfsr_out;
        begin
            if (expected_lfsr_out === (expected_lfsr_out ^ lfsr_out ^ expected_lfsr_out)) begin
                $display("PASS");
                $display("  Outputs: lfsr_out=%h",
                         lfsr_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lfsr_out=%h",
                         expected_lfsr_out);
                $display("  Got:      lfsr_out=%h",
                         lfsr_out);
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
        $dumpvars(0,clk, enable, reset, lfsr_out);
    end

endmodule
