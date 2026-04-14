`timescale 1ns/1ps

module karnaugh_map_4bit_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg D;
    wire F;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    karnaugh_map_4bit dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .F(F)
    );
    task testcase001;

    begin
        {A, B, C, D} = 4'b0000;
        $display("Test 001: Input 0000");
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        {A, B, C, D} = 4'b0001;
        $display("Test 002: Input 0001");
        #1;

        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        {A, B, C, D} = 4'b0010;
        $display("Test 003: Input 0010");
        #1;

        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        {A, B, C, D} = 4'b0011;
        $display("Test 004: Input 0011");
        #1;

        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        {A, B, C, D} = 4'b0100;
        $display("Test 005: Input 0100");
        #1;

        check_outputs(1);
    end
        endtask

    task testcase006;

    begin
        {A, B, C, D} = 4'b0101;
        $display("Test 006: Input 0101");
        #1;

        check_outputs(0);
    end
        endtask

    task testcase007;

    begin
        {A, B, C, D} = 4'b0110;
        $display("Test 007: Input 0110");
        #1;

        check_outputs(1);
    end
        endtask

    task testcase008;

    begin
        {A, B, C, D} = 4'b0111;
        $display("Test 008: Input 0111");
        #1;

        check_outputs(0);
    end
        endtask

    task testcase009;

    begin
        {A, B, C, D} = 4'b1000;
        $display("Test 009: Input 1000");
        #1;

        check_outputs(0);
    end
        endtask

    task testcase010;

    begin
        {A, B, C, D} = 4'b1001;
        $display("Test 010: Input 1001");
        #1;

        check_outputs(1);
    end
        endtask

    task testcase011;

    begin
        {A, B, C, D} = 4'b1010;
        $display("Test 011: Input 1010");
        #1;

        check_outputs(0);
    end
        endtask

    task testcase012;

    begin
        {A, B, C, D} = 4'b1011;
        $display("Test 012: Input 1011");
        #1;

        check_outputs(1);
    end
        endtask

    task testcase013;

    begin
        {A, B, C, D} = 4'b1100;
        $display("Test 013: Input 1100");
        #1;

        check_outputs(1);
    end
        endtask

    task testcase014;

    begin
        {A, B, C, D} = 4'b1101;
        $display("Test 014: Input 1101");
        #1;

        check_outputs(0);
    end
        endtask

    task testcase015;

    begin
        {A, B, C, D} = 4'b1110;
        $display("Test 015: Input 1110");
        #1;

        check_outputs(1);
    end
        endtask

    task testcase016;

    begin
        {A, B, C, D} = 4'b1111;
        $display("Test 016: Input 1111");
        #1;

        check_outputs(0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("karnaugh_map_4bit Testbench");
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
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input expected_F;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_F === (expected_F ^ F ^ expected_F)) begin
                $display("PASS");
                $display("  Outputs: F=%b",
                         F);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: F=%b",
                         expected_F);
                $display("  Got:      F=%b",
                         F);
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
