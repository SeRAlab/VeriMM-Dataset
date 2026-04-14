`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ADD;
    reg [3:0] BC;
    reg [3:0] EXT;
    reg [7:0] ORDER;
    reg [3:0] REG;
    reg [3:0] SUBC;
    wire [3:0] OUTPUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADD(ADD),
        .BC(BC),
        .EXT(EXT),
        .ORDER(ORDER),
        .REG(REG),
        .SUBC(SUBC),
        .OUTPUT(OUTPUT)
    );
    task testcase001;

    begin
        ORDER = 8'b1100_0000;
        #10;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase002;

    begin
        ORDER = 8'b0100_0000;
        #10;
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase003;

    begin
        ORDER = 8'b0010_0000;
        #10;
        #1;

        check_outputs(4'h2);
    end
        endtask

    task testcase004;

    begin
        ORDER = 8'b0001_0000;
        #10;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase005;

    begin
        ORDER = 8'b0000_0000;
        #10;
        #1;

        check_outputs(4'h4);
    end
        endtask

    task testcase006;

    begin
        ORDER = 8'b1010_0000;
        #10;
        #1;

        check_outputs(4'h2);
    end
        endtask

    task testcase007;

    begin
        ORDER = 8'b0110_0000;
        #10;
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase008;

    begin
        ORDER = 8'b1000_0000;
        #10;
        #1;

        check_outputs(4'h4);
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
        input [3:0] expected_OUTPUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUTPUT === (expected_OUTPUT ^ OUTPUT ^ expected_OUTPUT)) begin
                $display("PASS");
                $display("  Outputs: OUTPUT=%h",
                         OUTPUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUTPUT=%h",
                         expected_OUTPUT);
                $display("  Got:      OUTPUT=%h",
                         OUTPUT);
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
