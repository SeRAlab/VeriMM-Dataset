`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] dataa;
    reg [31:0] datab;
    wire overflow;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dataa(dataa),
        .datab(datab),
        .overflow(overflow),
        .result(result)
    );
    task testcase001;

    begin
        dataa = 32'h00000000;
        datab = 32'h00000000;
        #1;

        check_outputs(1'b0, 32'h00000000);
    end
        endtask

    task testcase002;

    begin
        dataa = 32'h00000005;
        datab = 32'h0000000A;
        #1;

        check_outputs(1'b0, 32'h0000000F);
    end
        endtask

    task testcase003;

    begin
        dataa = 32'h7FFFFFFF;
        datab = 32'h00000001;
        #1;

        check_outputs(1'b0, 32'h80000000);
    end
        endtask

    task testcase004;

    begin
        dataa = 32'hFFFFFFFF;
        datab = 32'h00000001;
        #1;

        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase005;

    begin
        dataa = 32'hFFFFFFFF;
        datab = 32'hFFFFFFFF;
        #1;

        check_outputs(1'b1, 32'hFFFFFFFE);
    end
        endtask

    task testcase006;

    begin
        dataa = 32'h80000000;
        datab = 32'h80000000;
        #1;

        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase007;

    begin
        dataa = 32'hAAAAAAAA;
        datab = 32'h55555555;
        #1;

        check_outputs(1'b0, 32'hFFFFFFFF);
    end
        endtask

    task testcase008;

    begin
        dataa = 32'hFFFFFFFE;
        datab = 32'h00000001;
        #1;

        check_outputs(1'b0, 32'hFFFFFFFF);
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
        input expected_overflow;
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, result=%h",
                         overflow, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, result=%h",
                         expected_overflow, expected_result);
                $display("  Got:      overflow=%b, result=%h",
                         overflow, result);
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
