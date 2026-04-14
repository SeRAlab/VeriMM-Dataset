`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] A1;
    reg [1:0] A2;
    reg [1:0] B1;
    reg [1:0] B2;
    reg [1:0] C1;
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A1(A1),
        .A2(A2),
        .B1(B1),
        .B2(B2),
        .C1(C1),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .X(X)
    );
    task reset_inputs;

        begin
            A1 = 2'b00;
            A2 = 2'b00;
            B1 = 2'b00;
            B2 = 2'b00;
            C1 = 2'b00;
            VPWR = 1'b1;
            VGND = 1'b0;
            VPB  = 1'b1;
            VNB  = 1'b0;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Perfect match, power OK, C1=0", test_num);
            reset_inputs();
            A1 = 2'b10;
            B1 = 2'b10;
            A2 = 2'b01;
            B2 = 2'b01;
            C1 = 2'b00;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: A1 mismatch, power OK, C1=0", test_num);
            reset_inputs();
            A1 = 2'b11;
            B1 = 2'b10;
            A2 = 2'b01;
            B2 = 2'b01;
            C1 = 2'b00;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: A2 mismatch, power OK, C1=0", test_num);
            reset_inputs();
            A1 = 2'b10;
            B1 = 2'b10;
            A2 = 2'b11;
            B2 = 2'b00;
            C1 = 2'b00;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mismatch but C1[0] is active, power OK", test_num);
            reset_inputs();
            A1 = 2'b00;
            B1 = 2'b11;
            A2 = 2'b00;
            B2 = 2'b11;
            C1 = 2'b01;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mismatch but C1[1] is active, power OK", test_num);
            reset_inputs();
            A1 = 2'b00;
            B1 = 2'b11;
            A2 = 2'b00;
            B2 = 2'b11;
            C1 = 2'b10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Match but VPWR is low", test_num);
            reset_inputs();
            A1 = 2'b10;
            B1 = 2'b10;
            A2 = 2'b01;
            B2 = 2'b01;
            VPWR = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Match but VGND is high", test_num);
            reset_inputs();
            A1 = 2'b10;
            B1 = 2'b10;
            A2 = 2'b01;
            B2 = 2'b01;
            VGND = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Match but VPB (N-well bias) is low", test_num);
            reset_inputs();
            A1 = 2'b01;
            B1 = 2'b01;
            A2 = 2'b01;
            B2 = 2'b01;
            VPB = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Match but VNB (P-sub bias) is high", test_num);
            reset_inputs();
            A1 = 2'b11;
            B1 = 2'b11;
            A2 = 2'b11;
            B2 = 2'b11;
            VNB = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Match check with alternating bits", test_num);
            reset_inputs();
            A1 = 2'b10;
            B1 = 2'b10;
            A2 = 2'b10;
            B2 = 2'b10;
            C1 = 2'b00;
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
        input expected_X;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_X === (expected_X ^ X ^ expected_X)) begin
                $display("PASS");
                $display("  Outputs: X=%b",
                         X);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%b",
                         expected_X);
                $display("  Got:      X=%b",
                         X);
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
