`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [255:0] D;
    reg [7:0] S;
    wire M256;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .S(S),
        .M256(M256)
    );
    task testcase001;

        begin
            test_num = 1;
            D = 256'h0;
            S = 8'd0;
            D[0] = 1'b1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            D = 256'h0;
            S = 8'd0;
            D[0] = 1'b0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            D = 256'h0;
            S = 8'd255;
            D[255] = 1'b1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            D = 256'h0;
            S = 8'd255;
            D[255] = 1'b0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            D = 256'h0;
            S = 8'd128;
            D[128] = 1'b1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            D = {256{1'b1}};
            S = 8'd64;
            D[64] = 1'b0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            D = 256'hA5A5A5A5_A5A5A5A5_A5A5A5A5_A5A5A5A5_A5A5A5A5_A5A5A5A5_A5A5A5A5_A5A5A5A5;
            S = 8'd1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            D = 256'h5A5A5A5A_5A5A5A5A_5A5A5A5A_5A5A5A5A_5A5A5A5A_5A5A5A5A_5A5A5A5A_5A5A5A5A;
            S = 8'd1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            D = 256'h0;
            S = 8'd42;
            D[42] = 1'b1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            D = {256{1'b1}};
            S = 8'd200;
            D[200] = 1'b0;
            #10;
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
        input expected_M256;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_M256 === (expected_M256 ^ M256 ^ expected_M256)) begin
                $display("PASS");
                $display("  Outputs: M256=%b",
                         M256);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: M256=%b",
                         expected_M256);
                $display("  Got:      M256=%b",
                         M256);
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
