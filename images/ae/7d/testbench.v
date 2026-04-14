`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] D0;
    reg [3:0] D1;
    reg [3:0] D2;
    reg [3:0] D3;
    reg LOAD;
    reg RESET;
    wire [3:0] Q0;
    wire [3:0] Q1;
    wire [3:0] Q2;
    wire [3:0] Q3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D0(D0),
        .D1(D1),
        .D2(D2),
        .D3(D3),
        .LOAD(LOAD),
        .RESET(RESET),
        .Q0(Q0),
        .Q1(Q1),
        .Q2(Q2),
        .Q3(Q3)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RESET = 1;
            LOAD = 0;
            D0 = 4'h0;
            D1 = 4'h0;
            D2 = 4'h0;
            D3 = 4'h0;
            @(posedge CLK);
            #1;
            RESET = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Parallel Load", test_num);
            reset_dut();

            D0 = 4'hA; D1 = 4'hB; D2 = 4'hC; D3 = 4'hD;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;

            #1;


            check_outputs(4'hA, 4'hB, 4'hC, 4'hD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Shift after Load", test_num);
            reset_dut();


            D0 = 4'h1; D1 = 4'h2; D2 = 4'h3; D3 = 4'h4;
            LOAD = 1;
            @(posedge CLK);
            #1;


            LOAD = 0;
            D0 = 4'hF;
            @(posedge CLK);
            #1;


            #1;



            check_outputs(4'hF, 4'h1, 4'h2, 4'h3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Full Propagation (Shift 4 times)", test_num);
            reset_dut();

            LOAD = 0;

            D0 = 4'hE; @(posedge CLK); #1;

            D0 = 4'h0; @(posedge CLK); #1;
            D0 = 4'h0; @(posedge CLK); #1;
            D0 = 4'h0; @(posedge CLK); #1;

            #1;


            check_outputs(4'h0, 4'h0, 4'h0, 4'hE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load Override", test_num);
            reset_dut();


            LOAD = 0;
            D0 = 4'h7; @(posedge CLK);
            D0 = 4'h8; @(posedge CLK);
            #1;


            D0 = 4'h5; D1 = 4'h5; D2 = 4'h5; D3 = 4'h5;
            LOAD = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;

            #1;


            check_outputs(4'h5, 4'h5, 4'h5, 4'h5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Priority", test_num);
            reset_dut();


            D0 = 4'hF; D1 = 4'hF; D2 = 4'hF; D3 = 4'hF;
            LOAD = 1;
            RESET = 1;
            @(posedge CLK);
            #1;
            RESET = 0;
            LOAD = 0;


            #1;



            check_outputs(4'h0, 4'h0, 4'h0, 4'h0);
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
        input [3:0] expected_Q0;
        input [3:0] expected_Q1;
        input [3:0] expected_Q2;
        input [3:0] expected_Q3;
        begin
            if (expected_Q0 === (expected_Q0 ^ Q0 ^ expected_Q0) &&
                expected_Q1 === (expected_Q1 ^ Q1 ^ expected_Q1) &&
                expected_Q2 === (expected_Q2 ^ Q2 ^ expected_Q2) &&
                expected_Q3 === (expected_Q3 ^ Q3 ^ expected_Q3)) begin
                $display("PASS");
                $display("  Outputs: Q0=%h, Q1=%h, Q2=%h, Q3=%h",
                         Q0, Q1, Q2, Q3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q0=%h, Q1=%h, Q2=%h, Q3=%h",
                         expected_Q0, expected_Q1, expected_Q2, expected_Q3);
                $display("  Got:      Q0=%h, Q1=%h, Q2=%h, Q3=%h",
                         Q0, Q1, Q2, Q3);
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
        $dumpvars(0,CLK, D0, D1, D2, D3, LOAD, RESET, Q0, Q1, Q2, Q3);
    end

endmodule
