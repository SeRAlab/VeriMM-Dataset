`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] In_0;
    reg [2:0] In_1;
    reg [2:0] In_2;
    reg [1:0] select;
    wire [2:0] Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .In_0(In_0),
        .In_1(In_1),
        .In_2(In_2),
        .select(select),
        .Out(Out)
    );
    task testcase001;

    begin

        test_num = 1;
        In_0 = 3'b101;
        In_1 = 3'b000;
        In_2 = 3'b011;
        select = 2'b00;
        $display("Testcase %0d: select=00, expecting In_0 (101)", test_num);
        #1;

        check_outputs(3'b101);
    end
        endtask

    task testcase002;

    begin

        test_num = 2;
        In_0 = 3'b101;
        In_1 = 3'b010;
        In_2 = 3'b111;
        select = 2'b01;
        $display("Testcase %0d: select=01, expecting In_1 (010)", test_num);
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase003;

    begin

        test_num = 3;
        In_0 = 3'b000;
        In_1 = 3'b110;
        In_2 = 3'b111;
        select = 2'b10;
        $display("Testcase %0d: select=10, expecting In_2 (111)", test_num);
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase004;

    begin

        test_num = 4;
        In_0 = 3'b111;
        In_1 = 3'b111;
        In_2 = 3'b111;
        select = 2'b11;
        $display("Testcase %0d: select=11, expecting High-Z (zzz)", test_num);
        #1;

        check_outputs(3'bzzz);
    end
        endtask

    task testcase005;

    begin

        test_num = 5;
        In_0 = 3'b000;
        In_1 = 3'b111;
        In_2 = 3'b101;
        select = 2'b00;
        $display("Testcase %0d: select=00, expecting In_0 (000)", test_num);
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase006;

    begin

        test_num = 6;
        select = 2'b10;
        In_2 = 3'b100;
        $display("Testcase %0d: select=10, dynamically changing In_2 to 100", test_num);
        #1;

        check_outputs(3'b100);
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
        input [2:0] expected_Out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Out === (expected_Out ^ Out ^ expected_Out)) begin
                $display("PASS");
                $display("  Outputs: Out=%h",
                         Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out=%h",
                         expected_Out);
                $display("  Got:      Out=%h",
                         Out);
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
