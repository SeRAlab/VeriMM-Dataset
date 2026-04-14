`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] H;
    wire [3:0] D;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .H(H),
        .D(D)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (No Error)", test_num);
            H = 7'b0000000;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones (No Error)", test_num);
            H = 7'b1111111;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data 1011 (No Error)", test_num);
            H = 7'b1010101;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data 1011 (Error in H[6]/Pos 7)", test_num);
            H = 7'b0010101;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data 1011 (Error in H[5]/Pos 6)", test_num);
            H = 7'b1110101;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data 1011 (Error in H[4]/Pos 5)", test_num);
            H = 7'b1000101;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data 1011 (Error in H[2]/Pos 3)", test_num);
            H = 7'b1010001;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data 1011 (Error in Parity H[3]/Pos 4)", test_num);
            H = 7'b1011101;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data 1011 (Error in Parity H[1]/Pos 2)", test_num);
            H = 7'b1010111;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data 1011 (Error in Parity H[0]/Pos 1)", test_num);
            H = 7'b1010100;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data 0110 (No Error)", test_num);
            H = 7'b0110011;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data 0110 (Error in H[5]/Pos 6)", test_num);
            H = 7'b0010011;
            #1;

            check_outputs(4'b0110);
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
        testcase011();
        testcase012();
        
        
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
        input [3:0] expected_D;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_D === (expected_D ^ D ^ expected_D)) begin
                $display("PASS");
                $display("  Outputs: D=%h",
                         D);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D=%h",
                         expected_D);
                $display("  Got:      D=%h",
                         D);
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
