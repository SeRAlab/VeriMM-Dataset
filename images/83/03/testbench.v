`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg I0;
    reg I1;
    reg clk;
    wire O0;
    wire O1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I0(I0),
        .I1(I1),
        .clk(clk),
        .O0(O0),
        .O1(O1)
    );

        task reset_dut;

        begin
            I0 = 0;
            I1 = 0;


            repeat(25) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: I0 stable High for 20+ cycles", test_num);
            reset_dut();

            @(posedge clk);
            I0 = 1;


            repeat(21) @(posedge clk);

            #1;


            check_outputs(1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: I0 glitch (High for 10 cycles, then Low)", test_num);
            reset_dut();

            @(posedge clk);
            I0 = 1;
            repeat(10) @(posedge clk);
            I0 = 0;


            repeat(25) @(posedge clk);

            #1;


            check_outputs(0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: I1 chatter then stable High", test_num);
            reset_dut();

            @(posedge clk);

            repeat(5) begin
                I1 = 1; repeat(5) @(posedge clk);
                I1 = 0; repeat(5) @(posedge clk);
            end


            I1 = 1;
            repeat(21) @(posedge clk);

            #1;


            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Both I0 and I1 stable High", test_num);
            reset_dut();

            @(posedge clk);
            I0 = 1;
            I1 = 1;

            repeat(21) @(posedge clk);

            #1;


            check_outputs(1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Return to stable Low", test_num);
            reset_dut();


            @(posedge clk);
            I0 = 1;
            repeat(21) @(posedge clk);


            @(posedge clk);
            I0 = 0;
            repeat(21) @(posedge clk);

            #1;


            check_outputs(0, 0);
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
        input expected_O0;
        input expected_O1;
        begin
            if (expected_O0 === (expected_O0 ^ O0 ^ expected_O0) &&
                expected_O1 === (expected_O1 ^ O1 ^ expected_O1)) begin
                $display("PASS");
                $display("  Outputs: O0=%b, O1=%b",
                         O0, O1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O0=%b, O1=%b",
                         expected_O0, expected_O1);
                $display("  Got:      O0=%b, O1=%b",
                         O0, O1);
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
        $dumpvars(0,I0, I1, clk, O0, O1);
    end

endmodule
