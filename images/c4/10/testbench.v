`timescale 1ns/1ps

module lut_ff_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in0;
    reg in1;
    reg in2;
    reg in3;
    reg in4;
    reg reset;
    wire q0;
    wire q1;
    wire q2;
    wire q3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lut_ff dut (
        .clk(clk),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .reset(reset),
        .q0(q0),
        .q1(q1),
        .q2(q2),
        .q3(q3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in0 = 0; in1 = 0; in2 = 0; in3 = 0; in4 = 0;
            #15;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All Inputs 0", test_num);
            reset_dut();
            in0 = 0; in1 = 0; in2 = 0; in3 = 0; in4 = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: All Inputs 1", test_num);
            reset_dut();
            in0 = 1; in1 = 1; in2 = 1; in3 = 1; in4 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Partial Ones (in0=0)", test_num);
            reset_dut();
            in0 = 0; in1 = 1; in2 = 1; in3 = 1; in4 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Partial Ones (in4=0)", test_num);
            reset_dut();
            in0 = 1; in1 = 1; in2 = 1; in3 = 1; in4 = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Asynchronous Reset Priority", test_num);
            reset_dut();

            in0 = 1; in1 = 1; in2 = 1; in3 = 1; in4 = 1;
            @(posedge clk);
            #2;

            reset = 1;
            #2;

            #1;


            check_outputs(0, 0, 0, 0);
            reset = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lut_ff Testbench");
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
        input expected_q0;
        input expected_q1;
        input expected_q2;
        input expected_q3;
        begin
            if (expected_q0 === (expected_q0 ^ q0 ^ expected_q0) &&
                expected_q1 === (expected_q1 ^ q1 ^ expected_q1) &&
                expected_q2 === (expected_q2 ^ q2 ^ expected_q2) &&
                expected_q3 === (expected_q3 ^ q3 ^ expected_q3)) begin
                $display("PASS");
                $display("  Outputs: q0=%b, q1=%b, q2=%b, q3=%b",
                         q0, q1, q2, q3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q0=%b, q1=%b, q2=%b, q3=%b",
                         expected_q0, expected_q1, expected_q2, expected_q3);
                $display("  Got:      q0=%b, q1=%b, q2=%b, q3=%b",
                         q0, q1, q2, q3);
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
        $dumpvars(0,clk, in0, in1, in2, in3, in4, reset, q0, q1, q2, q3);
    end

endmodule
