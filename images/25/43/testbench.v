`timescale 1ns/1ps

module mux_16_to_1_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] I;
    reg [3:0] S;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_16_to_1 dut (
        .I(I),
        .S(S),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select index 0, Input bit 0 is 1", test_num);
        I = 16'h0001;
        S = 4'd0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select index 15, Input bit 15 is 1", test_num);
        I = 16'h8000;
        S = 4'd15;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select index 7, Input bit 7 is 1", test_num);
        I = 16'h0080;
        S = 4'd7;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select index 7, Input bit 7 is 0", test_num);
        I = 16'hFF7F;
        S = 4'd7;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs high, select index 3", test_num);
        I = 16'hFFFF;
        S = 4'd3;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs low, select index 12", test_num);
        I = 16'h0000;
        S = 4'd12;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating pattern (AAAA), select index 1 (odd)", test_num);
        I = 16'hAAAA;
        S = 4'd1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating pattern (AAAA), select index 0 (even)", test_num);
        I = 16'hAAAA;
        S = 4'd0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select index 4, bit 4 is 1", test_num);
        I = 16'h0010;
        S = 4'd4;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select index 11, bit 11 is 0", test_num);
        I = 16'hF7FF;
        S = 4'd11;
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
        $display("mux_16_to_1 Testbench");
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
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
                         Y);
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
