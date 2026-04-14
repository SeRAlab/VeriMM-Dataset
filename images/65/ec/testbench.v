`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg gate;
    reg oflow_Clr;
    reg oflow_in;
    wire oflow_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .gate(gate),
        .oflow_Clr(oflow_Clr),
        .oflow_in(oflow_in),
        .oflow_state(oflow_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            oflow_Clr = 1'b1;
            gate = 1'b0;
            oflow_in = 1'b0;
            @(posedge clk);
            #1;
            oflow_Clr = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            gate = 1'b1;
            oflow_in = 1'b1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Basic Set", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            gate = 1'b0;
            oflow_in = 1'b1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Gate Block", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            gate = 1'b1;
            oflow_in = 1'b0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Input Low Block", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();

            gate = 1'b1;
            oflow_in = 1'b1;
            @(posedge clk);
            #1;

            gate = 1'b0;
            oflow_in = 1'b0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Latching Persistence", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();

            gate = 1'b1;
            oflow_in = 1'b1;
            @(posedge clk);
            #1;

            oflow_Clr = 1'b1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Clear Function", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            oflow_Clr = 1'b1;
            gate = 1'b1;
            oflow_in = 1'b1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Clear Priority", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();

            gate = 1'b1; oflow_in = 1'b0;
            @(posedge clk);

            gate = 1'b1; oflow_in = 1'b1;
            @(posedge clk);

            oflow_Clr = 1'b1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Multiple Cycles Sequence", test_num);
            #1;

            check_outputs(1'b0);
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
        input expected_oflow_state;
        begin
            if (expected_oflow_state === (expected_oflow_state ^ oflow_state ^ expected_oflow_state)) begin
                $display("PASS");
                $display("  Outputs: oflow_state=%b",
                         oflow_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oflow_state=%b",
                         expected_oflow_state);
                $display("  Got:      oflow_state=%b",
                         oflow_state);
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
        $dumpvars(0,clk, gate, oflow_Clr, oflow_in, oflow_state);
    end

endmodule
