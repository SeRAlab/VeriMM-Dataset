`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk1;
    reg clk2;
    reg clk3;
    wire [1:0] E_light;
    wire [1:0] N_light;
    wire [1:0] S_light;
    wire [1:0] W_light;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk1(clk1),
        .clk2(clk2),
        .clk3(clk3),
        .E_light(E_light),
        .N_light(N_light),
        .S_light(S_light),
        .W_light(W_light)
    );

    // Clock generation (10ns period)
    initial begin
        clk1 = 0;
        forever #5 clk1 = ~clk1;
    end

        task reset_dut;

        begin
            clk2 = 0;
            clk3 = 0;
            #10;
            clk3 = 1;
            #10;
            clk3 = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: System Reset via clk3", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00, 2'b00, 2'b01, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Start Sequence via clk1", test_num);
            reset_dut();
            @(posedge clk1);
            #2;

            #1;


            check_outputs(2'b00, 2'b00, 2'b01, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition to West Light (clk1 -> clk2)", test_num);
            reset_dut();
            @(posedge clk1);
            #5;
            clk2 = 1;
            #10;
            clk2 = 0;
            #5;

            #1;


            check_outputs(2'b00, 2'b00, 2'b00, 2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition to North Light (clk1 -> 2x clk2)", test_num);
            reset_dut();
            @(posedge clk1);
            #5;
            repeat(2) begin
                clk2 = 1;
                #10;
                clk2 = 0;
                #10;
            end

            #1;


            check_outputs(2'b00, 2'b01, 2'b00, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition to East Light (clk1 -> 3x clk2)", test_num);
            reset_dut();
            @(posedge clk1);
            #5;
            repeat(3) begin
                clk2 = 1;
                #10;
                clk2 = 0;
                #10;
            end

            #1;


            check_outputs(2'b01, 2'b00, 2'b00, 2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: clk3 Interrupt Mid-sequence", test_num);
            reset_dut();
            @(posedge clk1);
            #5;
            clk2 = 1; #10; clk2 = 0; #10;
            clk3 = 1; #10; clk3 = 0; #5;

            #1;


            check_outputs(2'b00, 2'b00, 2'b01, 2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple clk1 pulses", test_num);
            reset_dut();
            @(posedge clk1);
            #5;
            clk2 = 1; #10; clk2 = 0; #10;
            @(posedge clk1);
            #5;

            #1;


            check_outputs(2'b00, 2'b00, 2'b01, 2'b00);
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
        input [1:0] expected_E_light;
        input [1:0] expected_N_light;
        input [1:0] expected_S_light;
        input [1:0] expected_W_light;
        begin
            if (expected_E_light === (expected_E_light ^ E_light ^ expected_E_light) &&
                expected_N_light === (expected_N_light ^ N_light ^ expected_N_light) &&
                expected_S_light === (expected_S_light ^ S_light ^ expected_S_light) &&
                expected_W_light === (expected_W_light ^ W_light ^ expected_W_light)) begin
                $display("PASS");
                $display("  Outputs: E_light=%h, N_light=%h, S_light=%h, W_light=%h",
                         E_light, N_light, S_light, W_light);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: E_light=%h, N_light=%h, S_light=%h, W_light=%h",
                         expected_E_light, expected_N_light, expected_S_light, expected_W_light);
                $display("  Got:      E_light=%h, N_light=%h, S_light=%h, W_light=%h",
                         E_light, N_light, S_light, W_light);
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
        $dumpvars(0,clk1, clk2, clk3, E_light, N_light, S_light, W_light);
    end

endmodule
