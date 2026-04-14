`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [3:0] D;
    reg GND;
    reg VDD;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .GND(GND),
        .VDD(VDD),
        .Y(Y)
    );

    // Clock generation (10ns period)
    initial begin
        GND = 0;
        forever #5 GND = ~GND;
    end

        task reset_dut;

        begin
            A = 4'h0;
            B = 4'h0;
            C = 4'h0;
            D = 4'h0;
            VDD = 0;
            @(posedge GND);
            #2;
            VDD = 1;
            @(posedge GND);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: All inputs zero (NOR expected 1)", test_num);
            reset_dut();
            A = 4'h0; B = 4'h0; C = 4'h0; D = 4'h0;
            @(posedge GND);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: A non-zero", test_num);
            reset_dut();
            A = 4'h1; B = 4'h0; C = 4'h0; D = 4'h0;
            @(posedge GND);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: B non-zero", test_num);
            reset_dut();
            A = 4'h0; B = 4'h8; C = 4'h0; D = 4'h0;
            @(posedge GND);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: C non-zero", test_num);
            reset_dut();
            A = 4'h0; B = 4'h0; C = 4'h4; D = 4'h0;
            @(posedge GND);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: D non-zero", test_num);
            reset_dut();
            A = 4'h0; B = 4'h0; C = 4'h0; D = 4'h2;
            @(posedge GND);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: All inputs MAX", test_num);
            reset_dut();
            A = 4'hF; B = 4'hF; C = 4'hF; D = 4'hF;
            @(posedge GND);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Return to all zero", test_num);
            reset_dut();
            A = 4'h0; B = 4'h0; C = 4'h0; D = 4'h0;
            @(posedge GND);
            #2;
            #1;

            check_outputs(1'b1);
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
        input expected_Y;
        begin
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
                         Y);
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
        $dumpvars(0,A, B, C, D, GND, VDD, Y);
    end

endmodule
