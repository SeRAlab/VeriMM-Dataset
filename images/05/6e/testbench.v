`timescale 1ns/1ps

module adder_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    wire CARRY_OUT;
    wire [31:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_32bit dut (
        .A(A),
        .B(B),
        .CARRY_OUT(CARRY_OUT),
        .SUM(SUM)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero addition", test_num);
        A = 32'h00000000;
        B = 32'h00000000;
        #1;

        check_outputs(1'b0, 32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Small values", test_num);
        A = 32'h00000005;
        B = 32'h0000000A;
        #1;

        check_outputs(1'b0, 32'h0000000F);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max value without carry-out", test_num);
        A = 32'hFFFFFFFF;
        B = 32'h00000000;
        #1;

        check_outputs(1'b0, 32'hFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Carry-out trigger (Max + 1)", test_num);
        A = 32'hFFFFFFFF;
        B = 32'h00000001;
        #1;

        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Large values with carry-out", test_num);
        A = 32'h80000000;
        B = 32'h80000000;
        #1;

        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All ones addition", test_num);
        A = 32'hFFFFFFFF;
        B = 32'hFFFFFFFF;
        #1;

        check_outputs(1'b1, 32'hFFFFFFFE);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating bit patterns", test_num);
        A = 32'hAAAAAAAA;
        B = 32'h55555555;
        #1;

        check_outputs(1'b0, 32'hFFFFFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Carry ripple check", test_num);
        A = 32'h0000FFFF;
        B = 32'h00000001;
        #1;

        check_outputs(1'b0, 32'h00010000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_32bit Testbench");
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
        input expected_CARRY_OUT;
        input [31:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CARRY_OUT === (expected_CARRY_OUT ^ CARRY_OUT ^ expected_CARRY_OUT) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: CARRY_OUT=%b, SUM=%h",
                         CARRY_OUT, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CARRY_OUT=%b, SUM=%h",
                         expected_CARRY_OUT, expected_SUM);
                $display("  Got:      CARRY_OUT=%b, SUM=%h",
                         CARRY_OUT, SUM);
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
