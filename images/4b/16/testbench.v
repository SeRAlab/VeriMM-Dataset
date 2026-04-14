`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] x;
    wire cfo;
    wire [15:0] o;
    wire ofo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .cfo(cfo),
        .o(o),
        .ofo(ofo)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros input", test_num);
            x = 16'h0000;
            #1;

            check_outputs(1'b0, 16'hFFFF, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Ones input", test_num);
            x = 16'hFFFF;
            #1;

            check_outputs(1'b0, 16'h0000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating pattern (AAAA)", test_num);
            x = 16'hAAAA;
            #1;

            check_outputs(1'b0, 16'h5555, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating pattern (5555)", test_num);
            x = 16'h5555;
            #1;

            check_outputs(1'b0, 16'hAAAA, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: High byte low byte swap pattern", test_num);
            x = 16'h00FF;
            #1;

            check_outputs(1'b0, 16'hFF00, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Nibble pattern (F0F0)", test_num);
            x = 16'hF0F0;
            #1;

            check_outputs(1'b0, 16'h0F0F, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sequential hex pattern (1234)", test_num);
            x = 16'h1234;
            #1;

            check_outputs(1'b0, 16'hEDCB, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: MSB only set", test_num);
            x = 16'h8000;
            #1;

            check_outputs(1'b0, 16'h7FFF, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: LSB only set", test_num);
            x = 16'h0001;
            #1;

            check_outputs(1'b0, 16'hFFFE, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Arbitrary pattern (C3C3)", test_num);
            x = 16'hC3C3;
            #1;

            check_outputs(1'b0, 16'h3C3C, 1'b0);
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
        input expected_cfo;
        input [15:0] expected_o;
        input expected_ofo;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cfo === (expected_cfo ^ cfo ^ expected_cfo) &&
                expected_o === (expected_o ^ o ^ expected_o) &&
                expected_ofo === (expected_ofo ^ ofo ^ expected_ofo)) begin
                $display("PASS");
                $display("  Outputs: cfo=%b, o=%h, ofo=%b",
                         cfo, o, ofo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cfo=%b, o=%h, ofo=%b",
                         expected_cfo, expected_o, expected_ofo);
                $display("  Got:      cfo=%b, o=%h, ofo=%b",
                         cfo, o, ofo);
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
