`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x;
    reg [3:0] y;
    reg [1:0] z;
    wire [3:0] w;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .z(z),
        .w(w)
    );
    task testcase001;

    begin
        test_num = 1;
        x = 4'b1010;
        y = 4'b1100;
        z = 2'd0;
        #10;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        x = 4'b1010;
        y = 4'b1100;
        z = 2'd1;
        #10;
        #1;

        check_outputs(4'b1110);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        x = 4'b1010;
        y = 4'b1100;
        z = 2'd2;
        #10;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        x = 4'b1111;
        y = 4'b0000;
        z = 2'd0;
        #10;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        x = 4'b1111;
        y = 4'b0000;
        z = 2'd1;
        #10;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        x = 4'b1111;
        y = 4'b1111;
        z = 2'd2;
        #10;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        x = 4'b0101;
        y = 4'b0011;
        z = 2'd0;
        #10;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        x = 4'b0101;
        y = 4'b0011;
        z = 2'd1;
        #10;
        #1;

        check_outputs(4'b0111);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        x = 4'b0101;
        y = 4'b0011;
        z = 2'd2;
        #10;
        #1;

        check_outputs(4'b0110);
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
        input [3:0] expected_w;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_w === (expected_w ^ w ^ expected_w)) begin
                $display("PASS");
                $display("  Outputs: w=%h",
                         w);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: w=%h",
                         expected_w);
                $display("  Got:      w=%h",
                         w);
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
