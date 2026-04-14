`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] D;
    reg EN;
    reg LOAD;
    reg RESET;
    wire [3:0] Q;
    wire [3:0] Q_N;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .EN(EN),
        .LOAD(LOAD),
        .RESET(RESET),
        .Q(Q),
        .Q_N(Q_N)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            @(negedge CLK);
            RESET = 1;
            EN = 0;
            LOAD = 0;
            D = 4'b0000;
            @(negedge CLK);
            RESET = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Functionality", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0, 4'hF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Load Functionality", test_num);
            reset_dut();
            @(negedge CLK);
            D = 4'hA;
            LOAD = 1;
            @(negedge CLK);
            LOAD = 0;
            #1;

            #1;


            check_outputs(4'hA, 4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Basic Increment", test_num);
            reset_dut();
            @(negedge CLK);
            EN = 1;
            repeat (3) @(negedge CLK);
            EN = 0;
            #1;

            #1;


            check_outputs(4'h3, 4'hC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Enable/Disable Toggle", test_num);
            reset_dut();
            @(negedge CLK);
            EN = 1;
            repeat (2) @(negedge CLK);
            EN = 0;
            repeat (2) @(negedge CLK);
            #1;

            #1;


            check_outputs(4'h2, 4'hD);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Wrap-around (15 to 0)", test_num);
            reset_dut();
            @(negedge CLK);
            D = 4'hF;
            LOAD = 1;
            @(negedge CLK);
            LOAD = 0;
            EN = 1;
            @(negedge CLK);
            EN = 0;
            #1;

            #1;


            check_outputs(4'h0, 4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Priority (Load over Enable)", test_num);
            reset_dut();
            @(negedge CLK);
            D = 4'h7;
            LOAD = 1;
            EN = 1;
            @(negedge CLK);
            LOAD = 0;
            EN = 0;
            #1;

            #1;


            check_outputs(4'h7, 4'h8);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Priority (Reset over Load)", test_num);
            reset_dut();
            @(negedge CLK);
            D = 4'hE;
            LOAD = 1;
            RESET = 1;
            @(negedge CLK);
            RESET = 0;
            LOAD = 0;
            #1;

            #1;


            check_outputs(4'h0, 4'hF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Complex Sequence", test_num);
            reset_dut();

            @(negedge CLK);
            D = 4'h5; LOAD = 1;
            @(negedge CLK);
            LOAD = 0; EN = 1;

            repeat (2) @(negedge CLK);
            EN = 0;
            #1;

            #1;


            check_outputs(4'h7, 4'h8);
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
        testcase008();
        
        
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
        input [3:0] expected_Q;
        input [3:0] expected_Q_N;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Q_N === (expected_Q_N ^ Q_N ^ expected_Q_N)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, Q_N=%h",
                         Q, Q_N);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, Q_N=%h",
                         expected_Q, expected_Q_N);
                $display("  Got:      Q=%h, Q_N=%h",
                         Q, Q_N);
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
        $dumpvars(0,CLK, D, EN, LOAD, RESET, Q, Q_N);
    end

endmodule
