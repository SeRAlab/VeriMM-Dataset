`timescale 1ns/1ps

module bin_to_7seg_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] B;
    wire [6:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bin_to_7seg dut (
        .B(B),
        .S(S)
    );
    task testcase001;

        begin
            test_num = 1;
            B = 4'h0;
            #10;
            $display("Test %0d: Input B=0 (Expected 0x3F)", test_num);
            #1;

            check_outputs(7'h3F);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            B = 4'h1;
            #10;
            $display("Test %0d: Input B=1 (Expected 0x06)", test_num);
            #1;

            check_outputs(7'h06);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            B = 4'h2;
            #10;
            $display("Test %0d: Input B=2 (Expected 0x5B)", test_num);
            #1;

            check_outputs(7'h5B);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            B = 4'h3;
            #10;
            $display("Test %0d: Input B=3 (Expected 0x4F)", test_num);
            #1;

            check_outputs(7'h4F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            B = 4'h4;
            #10;
            $display("Test %0d: Input B=4 (Expected 0x66)", test_num);
            #1;

            check_outputs(7'h66);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            B = 4'h5;
            #10;
            $display("Test %0d: Input B=5 (Expected 0x6D)", test_num);
            #1;

            check_outputs(7'h6D);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            B = 4'h6;
            #10;
            $display("Test %0d: Input B=6 (Expected 0x7D)", test_num);
            #1;

            check_outputs(7'h7D);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            B = 4'h7;
            #10;
            $display("Test %0d: Input B=7 (Expected 0x07)", test_num);
            #1;

            check_outputs(7'h07);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            B = 4'h8;
            #10;
            $display("Test %0d: Input B=8 (Expected 0x7F)", test_num);
            #1;

            check_outputs(7'h7F);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            B = 4'h9;
            #10;
            $display("Test %0d: Input B=9 (Expected 0x6F)", test_num);
            #1;

            check_outputs(7'h6F);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            B = 4'hA;
            #10;
            $display("Test %0d: Input B=A (Expected 0x77)", test_num);
            #1;

            check_outputs(7'h77);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            B = 4'hB;
            #10;
            $display("Test %0d: Input B=B (Expected 0x7C)", test_num);
            #1;

            check_outputs(7'h7C);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            B = 4'hC;
            #10;
            $display("Test %0d: Input B=C (Expected 0x39)", test_num);
            #1;

            check_outputs(7'h39);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            B = 4'hD;
            #10;
            $display("Test %0d: Input B=D (Expected 0x5E)", test_num);
            #1;

            check_outputs(7'h5E);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            B = 4'hE;
            #10;
            $display("Test %0d: Input B=E (Expected 0x79)", test_num);
            #1;

            check_outputs(7'h79);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            B = 4'hF;
            #10;
            $display("Test %0d: Input B=F (Expected 0x71)", test_num);
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
        $display("bin_to_7seg Testbench");
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
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [6:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%h",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h",
                         expected_S);
                $display("  Got:      S=%h",
                         S);
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
