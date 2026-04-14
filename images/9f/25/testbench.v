`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg cyin;
    wire [7:0] c;
    wire cyout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .cyin(cyin),
        .c(c),
        .cyout(cyout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros", test_num);
            a = 8'h00;
            b = 8'h00;
            cyin = 1'b0;
            #1;

            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Carry-in only", test_num);
            a = 8'h00;
            b = 8'h00;
            cyin = 1'b1;
            #1;

            check_outputs(8'h01, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple addition without carry", test_num);
            a = 8'h12;
            b = 8'h34;
            cyin = 1'b0;
            #1;

            check_outputs(8'h46, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition with carry-in", test_num);
            a = 8'h10;
            b = 8'h20;
            cyin = 1'b1;
            #1;

            check_outputs(8'h31, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum sum no overflow (0xFF + 0)", test_num);
            a = 8'hFF;
            b = 8'h00;
            cyin = 1'b0;
            #1;

            check_outputs(8'hFF, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary overflow (0xFF + 0x01)", test_num);
            a = 8'hFF;
            b = 8'h01;
            cyin = 1'b0;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overflow via carry-in (0xFE + 0x01 + 1)", test_num);
            a = 8'hFE;
            b = 8'h01;
            cyin = 1'b1;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Pattern addition (0x55 + 0xAA)", test_num);
            a = 8'h55;
            b = 8'hAA;
            cyin = 1'b0;
            #1;

            check_outputs(8'hFF, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Pattern addition with overflow (0x55 + 0xAA + 1)", test_num);
            a = 8'h55;
            b = 8'hAA;
            cyin = 1'b1;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All inputs maximum", test_num);
            a = 8'hFF;
            b = 8'hFF;
            cyin = 1'b1;
            #1;

            check_outputs(8'hFF, 1'b1);
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
        input [7:0] expected_c;
        input expected_cyout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c === (expected_c ^ c ^ expected_c) &&
                expected_cyout === (expected_cyout ^ cyout ^ expected_cyout)) begin
                $display("PASS");
                $display("  Outputs: c=%h, cyout=%b",
                         c, cyout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h, cyout=%b",
                         expected_c, expected_cyout);
                $display("  Got:      c=%h, cyout=%b",
                         c, cyout);
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
