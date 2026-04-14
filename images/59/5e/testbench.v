`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] v39966a;
    reg v4642b6;
    reg [7:0] v62bf25;
    wire veb2f59;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .v39966a(v39966a),
        .v4642b6(v4642b6),
        .v62bf25(v62bf25),
        .veb2f59(veb2f59)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros, Control Low", test_num);
            v4642b6 = 1'b0;
            v62bf25 = 8'h00;
            v39966a = 8'h00;
            #10;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros, Control High", test_num);
            v4642b6 = 1'b1;
            v62bf25 = 8'h00;
            v39966a = 8'h00;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones, Control Low", test_num);
            v4642b6 = 1'b0;
            v62bf25 = 8'hFF;
            v39966a = 8'hFF;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones, Control High", test_num);
            v4642b6 = 1'b1;
            v62bf25 = 8'hFF;
            v39966a = 8'hFF;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits AA/55, Control Low", test_num);
            v4642b6 = 1'b0;
            v62bf25 = 8'hAA;
            v39966a = 8'h55;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits 55/AA, Control High", test_num);
            v4642b6 = 1'b1;
            v62bf25 = 8'h55;
            v39966a = 8'hAA;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Value Check (Max/Min), Control Low", test_num);
            v4642b6 = 1'b0;
            v62bf25 = 8'hFF;
            v39966a = 8'h01;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Value Check (Min/Max), Control High", test_num);
            v4642b6 = 1'b1;
            v62bf25 = 8'h01;
            v39966a = 8'hFF;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking Bit Pattern, Control Low", test_num);
            v4642b6 = 1'b0;
            v62bf25 = 8'h80;
            v39966a = 8'h08;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Matching Mid-range Values, Control High", test_num);
            v4642b6 = 1'b1;
            v62bf25 = 8'h7F;
            v39966a = 8'h7F;
            #10;
            #1;

            check_outputs(1'b1);
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
        input expected_veb2f59;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_veb2f59 === (expected_veb2f59 ^ veb2f59 ^ expected_veb2f59)) begin
                $display("PASS");
                $display("  Outputs: veb2f59=%b",
                         veb2f59);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: veb2f59=%b",
                         expected_veb2f59);
                $display("  Got:      veb2f59=%b",
                         veb2f59);
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
