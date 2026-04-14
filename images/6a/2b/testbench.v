`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cin;
    reg [1:0] dataa;
    reg [1:0] datab;
    wire cout;
    wire [2:0] sumout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cin(cin),
        .dataa(dataa),
        .datab(datab),
        .cout(cout),
        .sumout(sumout)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All Zeros (0 + 0 + cin=0)", test_num);
            dataa = 2'b00;
            datab = 2'b00;
            cin   = 1'b0;
            #1;

            check_outputs(1'b0, 3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Addition (1 + 1 + cin=0)", test_num);
            dataa = 2'b01;
            datab = 2'b01;
            cin   = 1'b0;
            #1;

            check_outputs(1'b0, 3'b010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Carry In Only (0 + 0 + cin=1)", test_num);
            dataa = 2'b00;
            datab = 2'b00;
            cin   = 1'b1;
            #1;

            check_outputs(1'b0, 3'b001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Result with Carry Out (2 + 2 + cin=0)", test_num);
            dataa = 2'b10;
            datab = 2'b10;
            cin   = 1'b0;

            #1;


            check_outputs(1'b1, 3'b100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Result with Carry Out (3 + 1 + cin=0)", test_num);
            dataa = 2'b11;
            datab = 2'b01;
            cin   = 1'b0;

            #1;


            check_outputs(1'b1, 3'b100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Maximum Values (3 + 3 + cin=1)", test_num);
            dataa = 2'b11;
            datab = 2'b11;
            cin   = 1'b1;

            #1;


            check_outputs(1'b1, 3'b111);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Mid-range with Carry In (2 + 1 + cin=1)", test_num);
            dataa = 2'b10;
            datab = 2'b01;
            cin   = 1'b1;

            #1;


            check_outputs(1'b1, 3'b100);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Result just below Carry Out (1 + 2 + cin=0)", test_num);
            dataa = 2'b01;
            datab = 2'b10;
            cin   = 1'b0;

            #1;


            check_outputs(1'b0, 3'b011);
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
        input expected_cout;
        input [2:0] expected_sumout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_sumout === (expected_sumout ^ sumout ^ expected_sumout)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, sumout=%h",
                         cout, sumout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, sumout=%h",
                         expected_cout, expected_sumout);
                $display("  Got:      cout=%b, sumout=%h",
                         cout, sumout);
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
