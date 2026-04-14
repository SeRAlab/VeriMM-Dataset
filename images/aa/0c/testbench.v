`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] In;
    wire [3:0] Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .In(In),
        .Out(Out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input 4'h0 (Numeral 0)", test_num);
        In = 4'h0;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input 4'h1 (Numeral 1)", test_num);
        In = 4'h1;
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input 4'h5 (Numeral 5)", test_num);
        In = 4'h5;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input 4'h9 (Numeral 9)", test_num);
        In = 4'h9;
        #1;

        check_outputs(4'h9);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input 4'hA (Hex A)", test_num);
        In = 4'hA;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input 4'hC (Hex C)", test_num);
        In = 4'hC;
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input 4'hF (Hex F)", test_num);
        In = 4'hF;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input 4'h2 (Numeral 2)", test_num);
        In = 4'h2;
        #1;

        check_outputs(4'h2);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Checking unrecognized input behavior (Sample 1)", test_num);



        In = 4'hB;
        #1;

        check_outputs(4'hB);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input 4'h7 (Numeral 7)", test_num);
        In = 4'h7;
        #1;

        check_outputs(4'h7);
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
        input [3:0] expected_Out;
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
