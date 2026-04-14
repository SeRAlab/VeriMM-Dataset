`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] IO_CORE;
    reg TCK;
    wire [3:0] IO_CORE_LOGIC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IO_CORE(IO_CORE),
        .TCK(TCK),
        .IO_CORE_LOGIC(IO_CORE_LOGIC)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: All inputs zero", test_num);
        TCK = 0;
        IO_CORE = 4'b0000;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: AND input bit 0 high", test_num);
        IO_CORE = 4'b0001;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: AND inputs both high", test_num);
        IO_CORE = 4'b0011;
        #1;

        check_outputs(4'b0011);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: OR input bit 2 high", test_num);
        IO_CORE = 4'b0100;
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: OR input bit 3 high", test_num);
        IO_CORE = 4'b1000;
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: OR inputs both high", test_num);
        IO_CORE = 4'b1100;
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: All inputs high", test_num);
        IO_CORE = 4'b1111;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: Mixed logic (AND true, OR true)", test_num);
        IO_CORE = 4'b1011;
        #1;

        check_outputs(4'b1111);
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
        input [3:0] expected_IO_CORE_LOGIC;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_IO_CORE_LOGIC === (expected_IO_CORE_LOGIC ^ IO_CORE_LOGIC ^ expected_IO_CORE_LOGIC)) begin
                $display("PASS");
                $display("  Outputs: IO_CORE_LOGIC=%h",
                         IO_CORE_LOGIC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IO_CORE_LOGIC=%h",
                         expected_IO_CORE_LOGIC);
                $display("  Got:      IO_CORE_LOGIC=%h",
                         IO_CORE_LOGIC);
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

endmodule
