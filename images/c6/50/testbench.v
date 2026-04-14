`timescale 1ns/1ps

module sky130_fd_sc_hd__ha_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire COUT;
    wire SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sky130_fd_sc_hd__ha dut (
        .A(A),
        .B(B),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .COUT(COUT),
        .SUM(SUM)
    );
    task testcase001;

        begin
            $display("Test Case 001: Inputs A=0, B=0 at 120ns sequence");
            test_num = test_num + 1;

            A = 1'bx; B = 1'bx; VGND = 1'bx; VNB = 1'bx; VPB = 1'bx; VPWR = 1'bx;

            #20 A = 1'b0;
            #20 B = 1'b0;
            #20 VGND = 1'b0;
            #20 VNB = 1'b0;
            #20 VPB = 1'b0;
            #20 VPWR = 1'b0;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Inputs A=1, B=1 at 140ns");
            test_num = test_num + 1;

            A = 1'bx; B = 1'bx; VGND = 1'bx; VNB = 1'bx; VPB = 1'bx; VPWR = 1'bx;
            #140;
            A = 1'b1; B = 1'b1; VGND = 1'b1; VNB = 1'b1; VPB = 1'b1; VPWR = 1'b1;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Inputs A=0, B=0 at 260ns");
            test_num = test_num + 1;

            A = 1'bx; B = 1'bx; VGND = 1'bx; VNB = 1'bx; VPB = 1'bx; VPWR = 1'bx;
            #260;
            A = 1'b0; B = 1'b0; VGND = 1'b0; VNB = 1'b0; VPB = 1'b0; VPWR = 1'b0;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Inputs A=0, B=1 at 460ns sequence");
            test_num = test_num + 1;

            A = 1'bx; B = 1'bx; VGND = 1'bx; VNB = 1'bx; VPB = 1'bx; VPWR = 1'bx;

            #260 A = 1'b0; B = 1'b0; VGND = 1'b0; VNB = 1'b0; VPB = 1'b0; VPWR = 1'b0;

            #120 VPWR = 1'b1;
            #20  VPB = 1'b1;
            #20  VNB = 1'b1;
            #20  VGND = 1'b1;
            #20  B = 1'b1;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Inputs A=1, B=1 at 480ns");
            test_num = test_num + 1;

            A = 1'bx; B = 1'bx; VGND = 1'bx; VNB = 1'bx; VPB = 1'bx; VPWR = 1'bx;

            #260 A = 1'b0; B = 1'b0; VGND = 1'b0; VNB = 1'b0; VPB = 1'b0; VPWR = 1'b0;
            #120 VPWR = 1'b1;
            #20  VPB = 1'b1;
            #20  VNB = 1'b1;
            #20  VGND = 1'b1;
            #20  B = 1'b1;

            #20  A = 1'b1;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Inputs return to 'x' at 500ns");
            test_num = test_num + 1;

            A = 1'bx; B = 1'bx; VGND = 1'bx; VNB = 1'bx; VPB = 1'bx; VPWR = 1'bx;
            #500;
            A = 1'bx; B = 1'bx; VGND = 1'bx; VNB = 1'bx; VPB = 1'bx; VPWR = 1'bx;

            #1;


            check_outputs(1'bx, 1'bx);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sky130_fd_sc_hd__ha Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input expected_COUT;
        input expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_COUT === (expected_COUT ^ COUT ^ expected_COUT) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: COUT=%b, SUM=%b",
                         COUT, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUT=%b, SUM=%b",
                         expected_COUT, expected_SUM);
                $display("  Got:      COUT=%b, SUM=%b",
                         COUT, SUM);
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
