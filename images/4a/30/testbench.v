`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [41:0] fixed_num;
    wire [25:0] rounded_num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .fixed_num(fixed_num),
        .rounded_num(rounded_num)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            fixed_num = 42'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Zero value", test_num);
            fixed_num = 42'h00000000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(26'h0000000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Round down (0.499...)", test_num);

            fixed_num = {26'h5, 16'h7FFF};
            @(posedge clk);
            #2;
            #1;

            check_outputs(26'h0000005);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Round up (Exactly 0.5)", test_num);

            fixed_num = {26'h5, 16'h8000};
            @(posedge clk);
            #2;
            #1;

            check_outputs(26'h0000006);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Round up (0.999...)", test_num);

            fixed_num = {26'hA, 16'hFFFF};
            @(posedge clk);
            #2;
            #1;

            check_outputs(26'h000000B);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Large value round down", test_num);

            fixed_num = {26'h3FFFFFF, 16'h0001};
            @(posedge clk);
            #2;
            #1;

            check_outputs(26'h3FFFFFF);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Round up with bit overflow", test_num);


            fixed_num = {26'h3FFFFFF, 16'h8000};
            @(posedge clk);
            #2;
            #1;

            check_outputs(26'h0000000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Zero integer round up", test_num);

            fixed_num = {26'h0, 16'hC000};
            @(posedge clk);
            #2;
            #1;

            check_outputs(26'h0000001);
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
        input [25:0] expected_rounded_num;
        begin
            if (expected_rounded_num === (expected_rounded_num ^ rounded_num ^ expected_rounded_num)) begin
                $display("PASS");
                $display("  Outputs: rounded_num=%h",
                         rounded_num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rounded_num=%h",
                         expected_rounded_num);
                $display("  Got:      rounded_num=%h",
                         rounded_num);
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
        $dumpvars(0,clk, fixed_num, rounded_num);
    end

endmodule
