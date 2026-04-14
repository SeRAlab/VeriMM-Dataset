`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] brType;
    reg carryFlag;
    reg overflowFlag;
    reg signFlag;
    reg zFlag;
    wire brTrue;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .brType(brType),
        .carryFlag(carryFlag),
        .overflowFlag(overflowFlag),
        .signFlag(signFlag),
        .zFlag(zFlag),
        .brTrue(brTrue)
    );
    task testcase001;

    begin
        test_num = 1;
        brType = 3'b000; zFlag = 0; carryFlag = 0; signFlag = 0; overflowFlag = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        brType = 3'b000; zFlag = 1; carryFlag = 0; signFlag = 0; overflowFlag = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        brType = 3'b100; zFlag = 1; carryFlag = 0; signFlag = 0; overflowFlag = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        brType = 3'b001; zFlag = 0; carryFlag = 0; signFlag = 0; overflowFlag = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        brType = 3'b101; zFlag = 1; carryFlag = 1; signFlag = 1; overflowFlag = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        brType = 3'b010; zFlag = 0; carryFlag = 0; signFlag = 0; overflowFlag = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        brType = 3'b110; zFlag = 0; carryFlag = 0; signFlag = 1; overflowFlag = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        brType = 3'b011; zFlag = 1; carryFlag = 1; signFlag = 1; overflowFlag = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        brType = 3'b111; zFlag = 0; carryFlag = 0; signFlag = 0; overflowFlag = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        brType = 3'b111; zFlag = 1; carryFlag = 1; signFlag = 1; overflowFlag = 0;
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
        input expected_brTrue;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_brTrue === (expected_brTrue ^ brTrue ^ expected_brTrue)) begin
                $display("PASS");
                $display("  Outputs: brTrue=%b",
                         brTrue);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: brTrue=%b",
                         expected_brTrue);
                $display("  Got:      brTrue=%b",
                         brTrue);
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
