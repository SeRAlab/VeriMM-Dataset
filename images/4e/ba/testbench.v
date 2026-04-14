`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] B;
    wire [3:0] S_B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .B(B),
        .S_B(S_B)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input All Zeros (6'b000000)", test_num);
            B = 6'b000000;
            #10;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input All Ones (6'b111111)", test_num);
            B = 6'b111111;
            #10;
            #1;

            check_outputs(4'hD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input LSB only (6'b000001)", test_num);
            B = 6'b000001;
            #10;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input MSB only (6'b100000)", test_num);
            B = 6'b100000;
            #10;
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits 1 (6'b010101)", test_num);
            B = 6'b010101;
            #10;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits 2 (6'b101010)", test_num);
            B = 6'b101010;
            #10;
            #1;

            check_outputs(4'h6);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Middle Bits Set (6'b011110)", test_num);
            B = 6'b011110;
            #10;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input pattern (6'b110011)", test_num);
            B = 6'b110011;
            #10;
            #1;

            check_outputs(4'hB);
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
        input [3:0] expected_S_B;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S_B === (expected_S_B ^ S_B ^ expected_S_B)) begin
                $display("PASS");
                $display("  Outputs: S_B=%h",
                         S_B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S_B=%h",
                         expected_S_B);
                $display("  Got:      S_B=%h",
                         S_B);
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
