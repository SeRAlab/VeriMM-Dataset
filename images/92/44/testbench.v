`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] input1;
    reg [1:0] input2;
    wire [5:0] output1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input1(input1),
        .input2(input2),
        .output1(output1)
    );

        task reset_dut;

        begin
            input1 = 4'b0000;
            input2 = 2'b00;
            #20;
            input2 = 2'b10;
            #20;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;


            #1;



            check_outputs(6'h13);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            input1 = 4'hA;
            input2 = 2'b10;
            #10;

            #1;


            check_outputs(6'h1D);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            input1 = 4'hA;
            #10;
            input2 = 2'b11;
            #10;

            #1;


            check_outputs(6'h0D);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            input1 = 4'hF;
            #10;
            input2 = 2'b11;
            #10;
            input1 = 4'h5;
            #10;

            #1;


            check_outputs(6'h26);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            input1 = 4'hE;
            #10;
            input2 = 2'b11;
            #10;
            input2 = 2'b10;
            #10;

            #1;


            check_outputs(6'h1D);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            input1 = 4'hF;
            input2 = 2'b11;
            #10;
            input2 = 2'b01;
            #10;

            #1;


            check_outputs(6'h15);
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
        input [5:0] expected_output1;
        begin
            if (expected_output1 === (expected_output1 ^ output1 ^ expected_output1)) begin
                $display("PASS");
                $display("  Outputs: output1=%h",
                         output1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output1=%h",
                         expected_output1);
                $display("  Got:      output1=%h",
                         output1);
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
        $dumpvars(0,input1, input2, output1);
    end

endmodule
