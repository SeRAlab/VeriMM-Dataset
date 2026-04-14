`timescale 1ns/1ps

module linear_feedback_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [7:0] lfsr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_feedback_shift_register dut (
        .clk(clk),
        .reset(reset),
        .lfsr(lfsr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Reset to 0x01", test_num);
            reset_dut();

            #1;


            check_outputs(8'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift after 1 clock cycle", test_num);
            reset_dut();
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h02);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift for 5 cycles (reaches tap 6)", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h20);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift for 6 cycles (feedback XOR triggered)", test_num);
            reset_dut();
            repeat(6) @(posedge clk);
            #1;



            #1;




            check_outputs(8'h41);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift for 8 cycles (tap 8 triggered)", test_num);
            reset_dut();
            repeat(8) @(posedge clk);
            #1;



            #1;




            check_outputs(8'h05);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift for 15 cycles", test_num);
            reset_dut();
            repeat(15) @(posedge clk);
            #1;






            #1;







            check_outputs(8'h88);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous reset triggered mid-sequence", test_num);
            reset_dut();
            repeat(10) @(posedge clk);
            reset_dut();
            #1;

            check_outputs(8'h01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("linear_feedback_shift_register Testbench");
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
        input [7:0] expected_lfsr;
        begin
            if (expected_lfsr === (expected_lfsr ^ lfsr ^ expected_lfsr)) begin
                $display("PASS");
                $display("  Outputs: lfsr=%h",
                         lfsr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lfsr=%h",
                         expected_lfsr);
                $display("  Got:      lfsr=%h",
                         lfsr);
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
        $dumpvars(0,clk, reset, lfsr);
    end

endmodule
