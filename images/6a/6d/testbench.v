`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] endianswapper_00014991_in;
    wire [31:0] endianswapper_00014991_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .endianswapper_00014991_in(endianswapper_00014991_in),
        .endianswapper_00014991_out(endianswapper_00014991_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            endianswapper_00014991_in = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            endianswapper_00014991_in = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Standard Endian Pattern 1", test_num);
            endianswapper_00014991_in = 32'h12345678;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Standard Endian Pattern 2", test_num);
            endianswapper_00014991_in = 32'h87654321;
            #1;

            check_outputs(32'h87654321);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits A", test_num);
            endianswapper_00014991_in = 32'hAAAAAAAA;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits 5", test_num);
            endianswapper_00014991_in = 32'h55555555;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Hex Word DEADBEEF", test_num);
            endianswapper_00014991_in = 32'hDEADBEEF;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Hex Word CAFEBABE", test_num);
            endianswapper_00014991_in = 32'hCAFEBABE;
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking One", test_num);
            endianswapper_00014991_in = 32'h00010000;
            #1;

            check_outputs(32'h00010000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Symmetric Nibbles", test_num);
            endianswapper_00014991_in = 32'hF00FBAAB;
            #1;

            check_outputs(32'hF00FBAAB);
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
        input [31:0] expected_endianswapper_00014991_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_endianswapper_00014991_out === (expected_endianswapper_00014991_out ^ endianswapper_00014991_out ^ expected_endianswapper_00014991_out)) begin
                $display("PASS");
                $display("  Outputs: endianswapper_00014991_out=%h",
                         endianswapper_00014991_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: endianswapper_00014991_out=%h",
                         expected_endianswapper_00014991_out);
                $display("  Got:      endianswapper_00014991_out=%h",
                         endianswapper_00014991_out);
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
