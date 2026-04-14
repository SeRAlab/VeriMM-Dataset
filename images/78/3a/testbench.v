`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLK;
    reg D;
    reg RESET_B;
    reg SCD;
    reg SCE;
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .RESET_B(RESET_B),
        .SCD(SCD),
        .SCE(SCE),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .Q(Q)
    );
    task initialize;

        begin
            CLK = 0;
            D = 0;
            SCD = 0;
            SCE = 0;
            RESET_B = 1;
            VPWR = 1;
            VGND = 0;
            VPB = 1;
            VNB = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            initialize();

            RESET_B = 1;
            #10;

            RESET_B = 0;
            #10;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            initialize();
            RESET_B = 0; #10; RESET_B = 1;

            D = 1;
            SCE = 1;
            SCD = 0;
            #10 CLK = 1;
            #10 CLK = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            initialize();
            RESET_B = 0; #10; RESET_B = 1;


            D = 1; SCE = 1;
            #10 CLK = 1; #10 CLK = 0;


            D = 0; SCE = 1;
            #10 CLK = 1; #10 CLK = 0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            initialize();
            RESET_B = 0; #10; RESET_B = 1;


            D = 1; SCE = 1;
            #10 CLK = 1; #10 CLK = 0;


            D = 0; SCE = 0;
            #10 CLK = 1; #10 CLK = 0;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            initialize();
            RESET_B = 0; #10; RESET_B = 1;


            D = 1; SCE = 1;
            #10 CLK = 1; #10 CLK = 0;


            SCD = 1;
            #10 CLK = 1; #10 CLK = 0;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            initialize();
            RESET_B = 0; #10; RESET_B = 1;


            D = 1;
            SCE = 1;
            SCD = 1;
            #10 CLK = 1; #10 CLK = 0;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            initialize();
            RESET_B = 0; #10; RESET_B = 1;


            D = 1;
            SCE = 0;
            SCD = 0;
            #10 CLK = 1; #10 CLK = 0;

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
        input expected_Q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
                         Q);
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
