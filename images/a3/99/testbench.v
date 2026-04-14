`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] I1;
    reg [9:0] I2;
    wire [9:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I1(I1),
        .I2(I2),
        .S(S)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        I1 = 10'h000;
        I2 = 10'h000;
        #1;

        check_outputs(10'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        I1 = 10'h3FF;
        I2 = 10'h3FF;
        #1;

        check_outputs(10'h3FF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        I1 = 10'h2AA;
        I2 = 10'h155;
        #1;

        check_outputs(10'h3FF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        I1 = 10'h155;
        I2 = 10'h2AA;
        #1;

        check_outputs(10'h000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        I1 = 10'h3FF;
        I2 = 10'h000;
        #1;

        check_outputs(10'h2AA);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        I1 = 10'h000;
        I2 = 10'h3FF;
        #1;

        check_outputs(10'h155);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        I1 = 10'h123;
        I2 = 10'h234;
        #1;

        check_outputs(10'h036);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        I1 = 10'h0F0;
        I2 = 10'h00F;
        #1;

        check_outputs(10'h0A5);
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
        input [9:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%h",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h",
                         expected_S);
                $display("  Got:      S=%h",
                         S);
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
