`timescale 1ns/1ps

module sky130_fd_sc_lp__or2b_2_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B_N;
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
    sky130_fd_sc_lp__or2b_2 dut (
        .A(A),
        .B_N(B_N),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .X(X)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: A=0, B_N=0 (Expected X=1)", test_num);

        VPWR = 1;
        VGND = 0;
        VPB  = 1;
        VNB  = 0;

        A = 0;
        B_N = 0;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: A=0, B_N=1 (Expected X=0)", test_num);

        VPWR = 1;
        VGND = 0;
        VPB  = 1;
        VNB  = 0;

        A = 0;
        B_N = 1;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: A=1, B_N=0 (Expected X=1)", test_num);

        VPWR = 1;
        VGND = 0;
        VPB  = 1;
        VNB  = 0;

        A = 1;
        B_N = 0;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: A=1, B_N=1 (Expected X=1)", test_num);

        VPWR = 1;
        VGND = 0;
        VPB  = 1;
        VNB  = 0;

        A = 1;
        B_N = 1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Voltage level change check (A=0, B_N=1 -> X=0)", test_num);

        VPWR = 1;
        VGND = 0;
        VPB  = 1;
        VNB  = 0;
        A = 0;
        B_N = 1;
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
        $display("sky130_fd_sc_lp__or2b_2 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
