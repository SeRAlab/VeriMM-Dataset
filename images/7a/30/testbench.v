`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [18:0] AddressBus;
    reg [18:0] TagData;
    wire Hit_H;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AddressBus(AddressBus),
        .TagData(TagData),
        .Hit_H(Hit_H)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros Match", test_num);
            AddressBus = 19'h00000;
            TagData    = 19'h00000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones Match", test_num);
            AddressBus = 19'h7FFFF;
            TagData    = 19'h7FFFF;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: LSB Mismatch", test_num);
            AddressBus = 19'h00001;
            TagData    = 19'h00000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: MSB Mismatch", test_num);
            AddressBus = 19'h40000;
            TagData    = 19'h00000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Pattern Match", test_num);
            AddressBus = 19'h5A5A5;
            TagData    = 19'h5A5A5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Middle Bit Mismatch", test_num);
            AddressBus = 19'h12345;
            TagData    = 19'h12745;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Bit-wise Inversion Mismatch", test_num);
            AddressBus = 19'h2AAAA;
            TagData    = 19'h55555;
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
        input expected_Hit_H;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Hit_H === (expected_Hit_H ^ Hit_H ^ expected_Hit_H)) begin
                $display("PASS");
                $display("  Outputs: Hit_H=%b",
                         Hit_H);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Hit_H=%b",
                         expected_Hit_H);
                $display("  Got:      Hit_H=%b",
                         Hit_H);
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
