`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] x1;
    reg [31:0] x2;
    wire v;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x1(x1),
        .x2(x2),
        .v(v)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            x1 = 32'h3f800000;
            x2 = 32'h3f800000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            x1 = 32'hbf800000;
            x2 = 32'hbf800000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            x1 = 32'h00000000;
            x2 = 32'h00000000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            x1 = 32'h80000000;
            x2 = 32'h80000000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            x1 = 32'h00000000;
            x2 = 32'h80000000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            x1 = 32'h80000000;
            x2 = 32'h00000000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            x1 = 32'h3f800000;
            x2 = 32'hbf800000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            x1 = 32'h3f800000;
            x2 = 32'h40000000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            x1 = 32'h3f800000;
            x2 = 32'h3f800001;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            x1 = 32'h7f800000;
            x2 = 32'h7f800000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            x1 = 32'h7f800000;
            x2 = 32'hff800000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            x1 = 32'h00000001;
            x2 = 32'h00000001;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase013;

        begin
            test_num = test_num + 1;
            x1 = 32'h00000000;
            x2 = 32'h00000001;
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
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        
        
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
        input expected_v;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_v === (expected_v ^ v ^ expected_v)) begin
                $display("PASS");
                $display("  Outputs: v=%b",
                         v);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: v=%b",
                         expected_v);
                $display("  Got:      v=%b",
                         v);
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
