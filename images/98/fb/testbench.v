`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] position;
    reg [2:0] rotor_type;
    wire knockpoint;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .position(position),
        .rotor_type(rotor_type),
        .knockpoint(knockpoint)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Rotor Type 0 at Position 16 (Expect 1)", test_num);
        rotor_type = 3'd0;
        position = 5'd16;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Rotor Type 0 at Position 0 (Expect 0)", test_num);
        rotor_type = 3'd0;
        position = 5'd0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Rotor Type 1 at Position 4 (Expect 1)", test_num);
        rotor_type = 3'd1;
        position = 5'd4;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Rotor Type 2 at Position 21 (Expect 1)", test_num);
        rotor_type = 3'd2;
        position = 5'd21;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Rotor Type 3 at Position 9 (Expect 1)", test_num);
        rotor_type = 3'd3;
        position = 5'd9;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Rotor Type 4 at Position 25 (Expect 1)", test_num);
        rotor_type = 3'd4;
        position = 5'd25;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Rotor Type 5 at Position 12 (Expect 1)", test_num);
        rotor_type = 3'd5;
        position = 5'd12;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Rotor Type 5 at Position 25 (Expect 1)", test_num);
        rotor_type = 3'd5;
        position = 5'd25;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Rotor Type 6 at Position 12 (Expect 1)", test_num);
        rotor_type = 3'd6;
        position = 5'd12;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Rotor Type 7 at Position 25 (Expect 1)", test_num);
        rotor_type = 3'd7;
        position = 5'd25;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Rotor Type 3 at Position 10 (Expect 0)", test_num);
        rotor_type = 3'd3;
        position = 5'd10;
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
        input expected_knockpoint;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_knockpoint === (expected_knockpoint ^ knockpoint ^ expected_knockpoint)) begin
                $display("PASS");
                $display("  Outputs: knockpoint=%b",
                         knockpoint);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: knockpoint=%b",
                         expected_knockpoint);
                $display("  Got:      knockpoint=%b",
                         knockpoint);
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
