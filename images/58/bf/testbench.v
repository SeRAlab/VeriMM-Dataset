`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] gin;
    wire [5:0] bout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .gin(gin),
        .bout(bout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            gin = 6'b000000;
            #1;

            check_outputs(6'b000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            gin = 6'b000001;
            #1;

            check_outputs(6'b000001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            gin = 6'b000011;
            #1;

            check_outputs(6'b000010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            gin = 6'b000010;
            #1;

            check_outputs(6'b000011);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            gin = 6'b100000;
            #1;

            check_outputs(6'b111111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            gin = 6'b111111;
            #1;

            check_outputs(6'b101010);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            gin = 6'b101010;
            #1;

            check_outputs(6'b110011);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            gin = 6'b011001;
            #1;

            check_outputs(6'b010001);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            gin = 6'b110110;
            #1;

            check_outputs(6'b100100);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            gin = 6'b111000;
            #1;

            check_outputs(6'b101111);
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
        input [5:0] expected_bout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bout === (expected_bout ^ bout ^ expected_bout)) begin
                $display("PASS");
                $display("  Outputs: bout=%h",
                         bout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bout=%h",
                         expected_bout);
                $display("  Got:      bout=%h",
                         bout);
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
