`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Greater;
    reg [27:0] M1;
    reg [27:0] M2;
    reg [7:0] r;
    wire [11:0] GRS_bits;
    wire [27:0] M1_norm;
    wire [27:0] M2_norm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Greater(Greater),
        .M1(M1),
        .M2(M2),
        .r(r),
        .GRS_bits(GRS_bits),
        .M1_norm(M1_norm),
        .M2_norm(M2_norm)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            M1 = 28'h1234567;
            M2 = 28'h89ABCDE;
            r = 8'd0;
            Greater = 1'b1;

            #1;


            check_outputs(12'h000, 28'h1234567, 28'h89ABCDE);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            M1 = 28'hAAAAAAA;
            M2 = 28'h5555555;
            r = 8'd4;
            Greater = 1'b1;


            #1;



            check_outputs(12'h500, 28'hAAAAAAA, 28'h0555555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            M1 = 28'hFFFFFFF;
            M2 = 28'hABCDE12;
            r = 8'd12;
            Greater = 1'b1;

            #1;


            check_outputs(12'hDE1, 28'hFFFFFFF, 28'h0000ABC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            M1 = 28'h1234567;
            M2 = 28'h89ABCDE;
            r = 8'd8;
            Greater = 1'b0;

            #1;


            check_outputs(12'h670, 28'h0012345, 28'h89ABCDE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            M1 = 28'hF0F0F0F;
            M2 = 28'h0000001;
            r = 8'd28;
            Greater = 1'b0;




            #1;





            check_outputs(12'hF0F, 28'h0000000, 28'h0000001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            M1 = 28'h8765432;
            M2 = 28'h0;
            r = 8'd32;
            Greater = 1'b1;

            #1;


            check_outputs(12'h000, 28'h8765432, 28'h0000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            M1 = 28'hABCDEFF;
            M2 = 28'hFFFFFFF;
            r = 8'd35;
            Greater = 1'b0;








            #1;









            check_outputs(12'h015, 28'h0000000, 28'hFFFFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            M1 = 28'h0000001;
            M2 = 28'hAAAAAAA;
            r = 8'd1;
            Greater = 1'b0;

            #1;


            check_outputs(12'h800, 28'h0000000, 28'hAAAAAAA);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            M1 = 28'hFFFFFFF;
            M2 = 28'hFFFFFFF;
            r = 8'd40;
            Greater = 1'b1;

            #1;


            check_outputs(12'h000, 28'hFFFFFFF, 28'h0000000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            M1 = 28'h5A5A5A5;
            M2 = 28'hA5A5A5A;
            r = 8'd4;
            Greater = 1'b0;

            #1;


            check_outputs(12'h500, 28'h05A5A5A, 28'hA5A5A5A);
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
        input [11:0] expected_GRS_bits;
        input [27:0] expected_M1_norm;
        input [27:0] expected_M2_norm;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_GRS_bits === (expected_GRS_bits ^ GRS_bits ^ expected_GRS_bits) &&
                expected_M1_norm === (expected_M1_norm ^ M1_norm ^ expected_M1_norm) &&
                expected_M2_norm === (expected_M2_norm ^ M2_norm ^ expected_M2_norm)) begin
                $display("PASS");
                $display("  Outputs: GRS_bits=%h, M1_norm=%h, M2_norm=%h",
                         GRS_bits, M1_norm, M2_norm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: GRS_bits=%h, M1_norm=%h, M2_norm=%h",
                         expected_GRS_bits, expected_M1_norm, expected_M2_norm);
                $display("  Got:      GRS_bits=%h, M1_norm=%h, M2_norm=%h",
                         GRS_bits, M1_norm, M2_norm);
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
