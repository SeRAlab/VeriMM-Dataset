`timescale 1ns/1ps

module binary_to_7seg_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] binary_input;
    wire [6:0] seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_to_7seg dut (
        .binary_input(binary_input),
        .seg(seg)
    );
    task testcase000;

        begin
            test_num = 0;
            binary_input = 4'h0;
            $display("Test Case %0d: Input 0", test_num);
            #1;

            check_outputs(7'h3F);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            binary_input = 4'h1;
            $display("Test Case %0d: Input 1", test_num);
            #1;

            check_outputs(7'h06);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            binary_input = 4'h2;
            $display("Test Case %0d: Input 2", test_num);
            #1;

            check_outputs(7'h5B);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            binary_input = 4'h3;
            $display("Test Case %0d: Input 3", test_num);
            #1;

            check_outputs(7'h4F);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            binary_input = 4'h4;
            $display("Test Case %0d: Input 4", test_num);
            #1;

            check_outputs(7'h66);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            binary_input = 4'h5;
            $display("Test Case %0d: Input 5", test_num);
            #1;

            check_outputs(7'h6D);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            binary_input = 4'h6;
            $display("Test Case %0d: Input 6", test_num);
            #1;

            check_outputs(7'h7D);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            binary_input = 4'h7;
            $display("Test Case %0d: Input 7", test_num);
            #1;

            check_outputs(7'h07);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            binary_input = 4'h8;
            $display("Test Case %0d: Input 8", test_num);
            #1;

            check_outputs(7'h7F);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            binary_input = 4'h9;
            $display("Test Case %0d: Input 9", test_num);
            #1;

            check_outputs(7'h6F);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            binary_input = 4'hA;
            $display("Test Case %0d: Input A", test_num);
            #1;

            check_outputs(7'h77);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            binary_input = 4'hB;
            $display("Test Case %0d: Input B", test_num);
            #1;

            check_outputs(7'h7C);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            binary_input = 4'hC;
            $display("Test Case %0d: Input C", test_num);
            #1;

            check_outputs(7'h39);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            binary_input = 4'hD;
            $display("Test Case %0d: Input D", test_num);
            #1;

            check_outputs(7'h5E);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            binary_input = 4'hE;
            $display("Test Case %0d: Input E", test_num);
            #1;

            check_outputs(7'h79);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            binary_input = 4'hF;
            $display("Test Case %0d: Input F", test_num);
            #1;

            check_outputs(7'h71);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_to_7seg Testbench");
        $display("========================================");


        testcase000();
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
        testcase013();
        testcase014();
        testcase015();
        
        
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
        input [6:0] expected_seg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_seg === (expected_seg ^ seg ^ expected_seg)) begin
                $display("PASS");
                $display("  Outputs: seg=%h",
                         seg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seg=%h",
                         expected_seg);
                $display("  Got:      seg=%h",
                         seg);
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
