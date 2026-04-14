`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CLR;
    reg [3:0] D;
    reg ENABLE;
    reg LOAD;
    reg UP;
    wire CO;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .CLR(CLR),
        .D(D),
        .ENABLE(ENABLE),
        .LOAD(LOAD),
        .UP(UP),
        .CO(CO),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            CLR = 1;
            LOAD = 0;
            ENABLE = 0;
            UP = 1;
            D = 0;
            @(posedge CLK);
            #1 CLR = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            D = 4'h5;
            LOAD = 1;
            @(posedge CLK);
            #1 LOAD = 0;
            #1;

            check_outputs(0, 4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            ENABLE = 1;
            UP = 1;
            @(posedge CLK);
            #1 #1;
 check_outputs(0, 4'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            D = 4'h5;
            LOAD = 1;
            @(posedge CLK);
            #1 LOAD = 0; ENABLE = 1; UP = 0;
            @(posedge CLK);
            #1 #1;
 check_outputs(0, 4'h4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            D = 4'h9;
            LOAD = 1;
            @(posedge CLK);
            #1 LOAD = 0; ENABLE = 1; UP = 1;

            if (CO !== 1'b1) $display("Note: CO not high at terminal count 9");
            @(posedge CLK);
            #1 #1;
 check_outputs(0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            ENABLE = 1;
            UP = 0;

            if (CO !== 1'b1) $display("Note: CO not high at terminal count 0");
            @(posedge CLK);
            #1 #1;
 check_outputs(0, 4'h9);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            D = 4'h3;
            LOAD = 1;
            @(posedge CLK);
            #1 LOAD = 0; ENABLE = 0; UP = 1;
            @(posedge CLK);
            @(posedge CLK);
            #1 #1;
 check_outputs(0, 4'h3);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            D = 4'h9;
            LOAD = 1;
            @(posedge CLK);
            #1 LOAD = 0; ENABLE = 1; UP = 1;
            #1 #1;
 check_outputs(1, 4'h9);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            ENABLE = 1;
            UP = 0;
            #1 #1;
 check_outputs(1, 4'h0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            D = 4'h7;
            LOAD = 1;
            ENABLE = 1;
            UP = 1;
            @(posedge CLK);
            #1 #1;
 check_outputs(0, 4'h7);
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
        testcase009();
        testcase010();
        
        
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
        input expected_CO;
        input [3:0] expected_Q;
        begin
            if (expected_CO === (expected_CO ^ CO ^ expected_CO) &&
                expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: CO=%b, Q=%h",
                         CO, Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CO=%b, Q=%h",
                         expected_CO, expected_Q);
                $display("  Got:      CO=%b, Q=%h",
                         CO, Q);
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
        $dumpvars(0,CLK, CLR, D, ENABLE, LOAD, UP, CO, Q);
    end

endmodule
