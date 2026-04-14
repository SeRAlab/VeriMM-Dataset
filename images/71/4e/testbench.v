`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] D;
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
    task init_power;

        begin
            VPWR = 1'b1;
            VGND = 1'b0;
            VPB  = 1'b1;
            VNB  = 1'b0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            init_power();
            S = 4'd0;
            D = 4'b1110;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            init_power();
            S = 4'd0;
            D = 4'b0001;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            init_power();
            S = 4'd1;
            D = 4'b1101;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            init_power();
            S = 4'd1;
            D = 4'b0010;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            init_power();
            S = 4'd2;
            D = 4'b1011;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            init_power();
            S = 4'd2;
            D = 4'b0100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            init_power();
            S = 4'd3;
            D = 4'b0111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            init_power();
            S = 4'd3;
            D = 4'b1000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            init_power();
            S = 4'd0;
            D = 4'b0001;
            #1;
            D = 4'b1111;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            init_power();
            S = 4'd3;
            D = 4'b0000;
            #1;
            D = 4'b0111;
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
