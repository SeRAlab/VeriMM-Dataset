`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [34:0] a;
    reg [34:0] b;
    reg valid;
    wire hit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .valid(valid),
        .hit(hit)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 35'h0_0000_0000;
            b = 35'h0_0000_0000;
            valid = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 35'h7_FFFF_FFFF;
            b = 35'h7_FFFF_FFFF;
            valid = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 35'h1_2345_6789;
            b = 35'h1_2345_6789;
            valid = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 35'h0_0000_0001;
            b = 35'h0_0000_0000;
            valid = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 35'h4_0000_0000;
            b = 35'h0_0000_0000;
            valid = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 35'h5_AAAA_AAAA;
            b = 35'h2_5555_5555;
            valid = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 35'h7_0000_F000;
            b = 35'h0_0000_000F;
            valid = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 35'h3_C3C3_C3C3;
            b = 35'h3_C3C3_C3C3;
            valid = 1'b0;
            #5;
            valid = 1'b1;
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
        input expected_hit;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hit === (expected_hit ^ hit ^ expected_hit)) begin
                $display("PASS");
                $display("  Outputs: hit=%b",
                         hit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hit=%b",
                         expected_hit);
                $display("  Got:      hit=%b",
                         hit);
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
