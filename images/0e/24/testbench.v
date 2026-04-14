`timescale 1ns/1ps

module mux16to1_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] I;
    reg [3:0] S;
    wire O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux16to1 dut (
        .I(I),
        .S(S),
        .O(O)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Select bit 0 (I[0]=1)", test_num);
        I = 16'h0001;
        S = 4'd0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Select bit 5 (I[5]=1)", test_num);
        I = 16'h0020;
        S = 4'd5;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Select bit 10 (I[10]=1)", test_num);
        I = 16'h0400;
        S = 4'd10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Select bit 15 (I[15]=1)", test_num);
        I = 16'h8000;
        S = 4'd15;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Verify bit 3 is 0 when others are 1", test_num);
        I = 16'hFFF7;
        S = 4'd3;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Pattern 0xAAAA (Alternating) - Select bit 1", test_num);
        I = 16'hAAAA;
        S = 4'd1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Pattern 0xAAAA (Alternating) - Select bit 0", test_num);
        I = 16'hAAAA;
        S = 4'd0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Pattern 0x5555 - Select bit 12", test_num);
        I = 16'h5555;
        S = 4'd12;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: All Inputs High", test_num);
        I = 16'hFFFF;
        S = 4'd9;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: All Inputs Low", test_num);
        I = 16'h0000;
        S = 4'd14;
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
        $display("mux16to1 Testbench");
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
        input expected_O;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%b",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%b",
                         expected_O);
                $display("  Got:      O=%b",
                         O);
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
