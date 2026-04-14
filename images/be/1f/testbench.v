`timescale 1ns/1ps

module seven_seg_decoder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] binary_in;
    wire [6:0] seg_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    seven_seg_decoder dut (
        .binary_in(binary_in),
        .seg_out(seg_out)
    );
    task testcase000;

        begin
            test_num = 0;
            binary_in = 4'h0;
            $display("Test Case %0d: Input 0", test_num);
            #1;

            check_outputs(7'h3f);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            binary_in = 4'h1;
            $display("Test Case %0d: Input 1", test_num);
            #1;

            check_outputs(7'h06);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            binary_in = 4'h2;
            $display("Test Case %0d: Input 2", test_num);
            #1;

            check_outputs(7'h5b);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            binary_in = 4'h3;
            $display("Test Case %0d: Input 3", test_num);
            #1;

            check_outputs(7'h4f);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            binary_in = 4'h4;
            $display("Test Case %0d: Input 4", test_num);
            #1;

            check_outputs(7'h66);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            binary_in = 4'h5;
            $display("Test Case %0d: Input 5", test_num);
            #1;

            check_outputs(7'h6d);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            binary_in = 4'h6;
            $display("Test Case %0d: Input 6", test_num);
            #1;

            check_outputs(7'h7d);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            binary_in = 4'h7;
            $display("Test Case %0d: Input 7", test_num);
            #1;

            check_outputs(7'h07);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            binary_in = 4'h8;
            $display("Test Case %0d: Input 8", test_num);
            #1;

            check_outputs(7'h7f);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            binary_in = 4'h9;
            $display("Test Case %0d: Input 9", test_num);
            #1;

            check_outputs(7'h6f);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            binary_in = 4'hA;
            $display("Test Case %0d: Input A", test_num);
            #1;

            check_outputs(7'h77);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            binary_in = 4'hB;
            $display("Test Case %0d: Input B", test_num);
            #1;

            check_outputs(7'h7c);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            binary_in = 4'hC;
            $display("Test Case %0d: Input C", test_num);
            #1;

            check_outputs(7'h39);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            binary_in = 4'hD;
            $display("Test Case %0d: Input D", test_num);
            #1;

            check_outputs(7'h5e);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            binary_in = 4'hE;
            $display("Test Case %0d: Input E", test_num);
            #1;

            check_outputs(7'h79);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            binary_in = 4'hF;
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
        $display("seven_seg_decoder Testbench");
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
        input [6:0] expected_seg_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_seg_out === (expected_seg_out ^ seg_out ^ expected_seg_out)) begin
                $display("PASS");
                $display("  Outputs: seg_out=%h",
                         seg_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seg_out=%h",
                         expected_seg_out);
                $display("  Got:      seg_out=%h",
                         seg_out);
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
