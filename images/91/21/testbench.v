`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] D;
    reg [3:0] S;
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .S(S),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .Z(Z)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Select bit 0", test_num);
        VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
        D = 16'h0001;
        S = 4'd0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Select bit 1", test_num);
        VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
        D = 16'h0002;
        S = 4'd1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Select bit 4", test_num);
        VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
        D = 16'h0010;
        S = 4'd4;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Select bit 7", test_num);
        VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
        D = 16'h0080;
        S = 4'd7;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Select bit 8", test_num);
        VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
        D = 16'h0100;
        S = 4'd8;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Select bit 15", test_num);
        VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
        D = 16'h8000;
        S = 4'd15;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: All Zeros, check index 5", test_num);
        VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
        D = 16'h0000;
        S = 4'd5;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: All Ones, check index 10", test_num);
        VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
        D = 16'hFFFF;
        S = 4'd10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Pattern 0101 (0xA), check index 0 (Expect 0)", test_num);
        VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
        D = 16'hAAAA;
        S = 4'd0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Pattern 0101 (0xA), check index 1 (Expect 1)", test_num);
        VPWR = 1; VGND = 0; VPB = 1; VNB = 0;
        D = 16'hAAAA;
        S = 4'd1;
        #1;

        check_outputs(1'b1);
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
        input expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%b",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%b",
                         expected_Z);
                $display("  Got:      Z=%b",
                         Z);
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
