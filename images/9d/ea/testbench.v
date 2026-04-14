`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x;
    wire valid;
    wire [2:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .valid(valid),
        .y(y)
    );
    task testcase001;

    begin
        test_num = 1;
        x = 8'b0000_0000;
        #10;
        #1;

        check_outputs(1'b0, 3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        x = 8'b0000_0001;
        #10;
        #1;

        check_outputs(1'b1, 3'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        x = 8'b0000_0010;
        #10;
        #1;

        check_outputs(1'b1, 3'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        x = 8'b0000_0100;
        #10;
        #1;

        check_outputs(1'b1, 3'd2);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        x = 8'b0000_1000;
        #10;
        #1;

        check_outputs(1'b1, 3'd3);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        x = 8'b0001_0000;
        #10;
        #1;

        check_outputs(1'b1, 3'd4);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        x = 8'b0010_0000;
        #10;
        #1;

        check_outputs(1'b1, 3'd5);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        x = 8'b0100_0000;
        #10;
        #1;

        check_outputs(1'b1, 3'd6);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        x = 8'b1000_0000;
        #10;
        #1;

        check_outputs(1'b1, 3'd7);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        x = 8'b1000_0001;
        #10;
        #1;

        check_outputs(1'b1, 3'd7);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        x = 8'b0001_0110;
        #10;
        #1;

        check_outputs(1'b1, 3'd4);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        x = 8'b1111_1111;
        #10;
        #1;

        check_outputs(1'b1, 3'd7);
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
        input expected_valid;
        input [2:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_valid === (expected_valid ^ valid ^ expected_valid) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: valid=%b, y=%h",
                         valid, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: valid=%b, y=%h",
                         expected_valid, expected_y);
                $display("  Got:      valid=%b, y=%h",
                         valid, y);
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
