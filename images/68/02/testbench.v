`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] x;
    wire [12:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        x = 9'h000;
        #10;
        $display("Testcase %0d: All Zeros", test_num);
        #1;

        check_outputs(rs_model(x));
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        x = 9'h1FF;
        #10;
        $display("Testcase %0d: All Ones", test_num);
        #1;

        check_outputs(rs_model(x));
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        x = 9'h001;
        #10;
        $display("Testcase %0d: LSB Only", test_num);
        #1;

        check_outputs(rs_model(x));
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        x = 9'h100;
        #10;
        $display("Testcase %0d: MSB Only", test_num);
        #1;

        check_outputs(rs_model(x));
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        x = 9'h0AA;
        #10;
        $display("Testcase %0d: Alternating Pattern 1010...", test_num);
        #1;

        check_outputs(rs_model(x));
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        x = 9'h155;
        #10;
        $display("Testcase %0d: Alternating Pattern 0101...", test_num);
        #1;

        check_outputs(rs_model(x));
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        x = 9'h010;
        #10;
        $display("Testcase %0d: Middle Bit Only", test_num);
        #1;

        check_outputs(rs_model(x));
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        x = 9'h00F;
        #10;
        $display("Testcase %0d: Low Nibble", test_num);
        #1;

        check_outputs(rs_model(x));
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        x = 9'h1F0;
        #10;
        $display("Testcase %0d: High Nibble", test_num);
        #1;

        check_outputs(rs_model(x));
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        x = 9'h123;
        #10;
        $display("Testcase %0d: Random Pattern 0x123", test_num);
        #1;

        check_outputs(rs_model(x));
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
        input [12:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
