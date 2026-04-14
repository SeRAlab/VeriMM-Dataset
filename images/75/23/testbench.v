`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] high_i;
    reg [31:0] low_i;
    wire [31:0] high_o;
    wire [31:0] low_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .high_i(high_i),
        .low_i(low_i),
        .high_o(high_o),
        .low_o(low_o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            high_i = 32'h00000000;
            low_i = 32'h00000000;
            #1;

            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones", test_num);
            high_i = 32'hFFFFFFFF;
            low_i = 32'hFFFFFFFF;


            #1;



            check_outputs(32'hFFFFFFFF, 32'hFFFFFFFE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Low MSB shift to High LSB", test_num);
            high_i = 32'h00000000;
            low_i = 32'h80000000;


            #1;



            check_outputs(32'h00000001, 32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High MSB discarded", test_num);
            high_i = 32'h80000000;
            low_i = 32'h00000000;


            #1;



            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits pattern 1", test_num);
            high_i = 32'h55555555;
            low_i = 32'hAAAAAAAA;


            #1;



            check_outputs(32'hAAAAAAAB, 32'h55555554);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits pattern 2", test_num);
            high_i = 32'hAAAAAAAA;
            low_i = 32'h55555555;


            #1;



            check_outputs(32'h55555554, 32'hAAAAAAAA);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Small value multiplication", test_num);
            high_i = 32'h00000000;
            low_i = 32'h00000005;


            #1;



            check_outputs(32'h00000000, 32'h0000000A);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random pattern verification", test_num);
            high_i = 32'h12345678;
            low_i = 32'h87654321;


            #1;



            check_outputs(32'h2468ACF1, 32'h0ECA8642);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary check - almost overflow low", test_num);
            high_i = 32'h00000000;
            low_i = 32'h7FFFFFFF;


            #1;



            check_outputs(32'h00000000, 32'hFFFFFFFE);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single bit high shift", test_num);
            high_i = 32'h00000001;
            low_i = 32'h00000000;

            #1;


            check_outputs(32'h00000002, 32'h00000000);
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
        input [31:0] expected_high_o;
        input [31:0] expected_low_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_high_o === (expected_high_o ^ high_o ^ expected_high_o) &&
                expected_low_o === (expected_low_o ^ low_o ^ expected_low_o)) begin
                $display("PASS");
                $display("  Outputs: high_o=%h, low_o=%h",
                         high_o, low_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: high_o=%h, low_o=%h",
                         expected_high_o, expected_low_o);
                $display("  Got:      high_o=%h, low_o=%h",
                         high_o, low_o);
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
