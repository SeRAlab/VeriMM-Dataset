`timescale 1ns/1ps

module binary_to_7segment_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bin;
    wire [6:0] seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_to_7segment dut (
        .bin(bin),
        .seg(seg)
    );
    task testcase001;

        begin
            test_num = 1;
            bin = 4'h0;
            $display("Test %0d: Input bin = 4'h0 (Display 0)", test_num);
            #1;

            check_outputs(7'h3F);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            bin = 4'h1;
            $display("Test %0d: Input bin = 4'h1 (Display 1)", test_num);
            #1;

            check_outputs(7'h06);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            bin = 4'h2;
            $display("Test %0d: Input bin = 4'h2 (Display 2)", test_num);
            #1;

            check_outputs(7'h5B);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            bin = 4'h3;
            $display("Test %0d: Input bin = 4'h3 (Display 3)", test_num);
            #1;

            check_outputs(7'h4F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            bin = 4'h4;
            $display("Test %0d: Input bin = 4'h4 (Display 4)", test_num);
            #1;

            check_outputs(7'h66);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            bin = 4'h5;
            $display("Test %0d: Input bin = 4'h5 (Display 5)", test_num);
            #1;

            check_outputs(7'h6D);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            bin = 4'h6;
            $display("Test %0d: Input bin = 4'h6 (Display 6)", test_num);
            #1;

            check_outputs(7'h7D);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            bin = 4'h7;
            $display("Test %0d: Input bin = 4'h7 (Display 7)", test_num);
            #1;

            check_outputs(7'h07);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            bin = 4'h8;
            $display("Test %0d: Input bin = 4'h8 (Display 8)", test_num);
            #1;

            check_outputs(7'h7F);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            bin = 4'h9;
            $display("Test %0d: Input bin = 4'h9 (Display 9)", test_num);
            #1;

            check_outputs(7'h6F);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            bin = 4'hA;
            $display("Test %0d: Input bin = 4'hA (Display A)", test_num);
            #1;

            check_outputs(7'h77);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            bin = 4'hB;
            $display("Test %0d: Input bin = 4'hB (Display b)", test_num);
            #1;

            check_outputs(7'h7C);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            bin = 4'hC;
            $display("Test %0d: Input bin = 4'hC (Display C)", test_num);
            #1;

            check_outputs(7'h39);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            bin = 4'hD;
            $display("Test %0d: Input bin = 4'hD (Display d)", test_num);
            #1;

            check_outputs(7'h5E);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            bin = 4'hE;
            $display("Test %0d: Input bin = 4'hE (Display E)", test_num);
            #1;

            check_outputs(7'h79);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            bin = 4'hF;
            $display("Test %0d: Input bin = 4'hF (Display F)", test_num);
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
        $display("binary_to_7segment Testbench");
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
