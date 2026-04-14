`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] D;
    reg [3:0] LOAD;
    reg RESET;
    reg UP_DOWN;
    wire [3:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .LOAD(LOAD),
        .RESET(RESET),
        .UP_DOWN(UP_DOWN),
        .OUT(OUT)
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
            D = 0;
            UP_DOWN = 0;
            @(posedge CLK);
            #1 RESET = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Reset", test_num);
            reset_dut();
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load Data", test_num);
            reset_dut();
            LOAD = 4'h7;
            D = 4'h2;
            @(posedge CLK);
            #1;
            LOAD = 4'h0;
            #1;

            check_outputs(4'h9);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment and Shift (D[0]=0)", test_num);
            reset_dut();
            LOAD = 4'h5; D = 4'h5;
            @(posedge CLK);
            #1;
            LOAD = 0; UP_DOWN = 1; D = 4'h0;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(4'h8);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Decrement and Shift (D[0]=1)", test_num);
            reset_dut();
            LOAD = 4'h5; D = 4'h5;
            @(posedge CLK);
            #1;
            LOAD = 0; UP_DOWN = 0; D = 4'h1;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(4'hE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Counter Wrap Around Up", test_num);
            reset_dut();
            LOAD = 4'hF; D = 4'h0;
            @(posedge CLK);
            #1;
            LOAD = 0; UP_DOWN = 1; D = 0;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Counter Wrap Around Down", test_num);
            reset_dut();
            LOAD = 4'h1; D = 4'h0;
            @(posedge CLK);
            #1;
            LOAD = 0; UP_DOWN = 0; D = 0;
            @(posedge CLK);
            #1;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Arithmetic Overflow Check", test_num);
            reset_dut();
            LOAD = 4'hC;
            D = 4'h8;
            @(posedge CLK);
            #1;
            LOAD = 0;

            #1;


            check_outputs(4'h4);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Shifting", test_num);
            reset_dut();
            UP_DOWN = 1; D = 4'h1;
            @(posedge CLK); #1;
            @(posedge CLK); #1;
            @(posedge CLK); #1;
            #1;

            check_outputs(4'h1);
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
        input [3:0] expected_OUT;
        begin
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: OUT=%h",
                         OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%h",
                         expected_OUT);
                $display("  Got:      OUT=%h",
                         OUT);
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
        $dumpvars(0,CLK, D, LOAD, RESET, UP_DOWN, OUT);
    end

endmodule
