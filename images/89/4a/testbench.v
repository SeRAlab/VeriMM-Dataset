`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] D;
    wire [3:0] anodes;
    wire [6:0] segs;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .anodes(anodes),
        .segs(segs)
    );
    task testcase001;

        begin
            test_num = 1;
            D = 4'h0;
            $display("Test %0d: Input D = %h (Display 0)", test_num, D);

            #1;


            check_outputs(4'b1110, 7'h40);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            D = 4'h1;
            $display("Test %0d: Input D = %h (Display 1)", test_num, D);

            #1;


            check_outputs(4'b1110, 7'h79);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            D = 4'h2;
            $display("Test %0d: Input D = %h (Display 2)", test_num, D);

            #1;


            check_outputs(4'b1110, 7'h24);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            D = 4'h3;
            $display("Test %0d: Input D = %h (Display 3)", test_num, D);

            #1;


            check_outputs(4'b1110, 7'h30);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            D = 4'h4;
            $display("Test %0d: Input D = %h (Display 4)", test_num, D);

            #1;


            check_outputs(4'b1110, 7'h19);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            D = 4'h5;
            $display("Test %0d: Input D = %h (Display 5)", test_num, D);

            #1;


            check_outputs(4'b1110, 7'h12);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            D = 4'h6;
            $display("Test %0d: Input D = %h (Display 6)", test_num, D);

            #1;


            check_outputs(4'b1110, 7'h02);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            D = 4'h7;
            $display("Test %0d: Input D = %h (Display 7)", test_num, D);

            #1;


            check_outputs(4'b1110, 7'h78);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            D = 4'h8;
            $display("Test %0d: Input D = %h (Display 8)", test_num, D);

            #1;


            check_outputs(4'b1110, 7'h00);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            D = 4'h9;
            $display("Test %0d: Input D = %h (Display 9)", test_num, D);

            #1;


            check_outputs(4'b1110, 7'h10);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            D = 4'hA;
            $display("Test %0d: Input D = %h (Display A)", test_num, D);

            #1;


            check_outputs(4'b1110, 7'h08);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            D = 4'hB;
            $display("Test %0d: Input D = %h (Display B)", test_num, D);

            #1;


            check_outputs(4'b1110, 7'h03);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            D = 4'hC;
            $display("Test %0d: Input D = %h (Display C)", test_num, D);

            #1;


            check_outputs(4'b1110, 7'h46);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            D = 4'hD;
            $display("Test %0d: Input D = %h (Display D)", test_num, D);

            #1;


            check_outputs(4'b1110, 7'h21);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            D = 4'hE;
            $display("Test %0d: Input D = %h (Display E)", test_num, D);

            #1;


            check_outputs(4'b1110, 7'h06);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            D = 4'hF;
            $display("Test %0d: Input D = %h (Display F)", test_num, D);

            #1;


            check_outputs(4'b1110, 7'h0E);
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
        input [3:0] expected_anodes;
        input [6:0] expected_segs;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_anodes === (expected_anodes ^ anodes ^ expected_anodes) &&
                expected_segs === (expected_segs ^ segs ^ expected_segs)) begin
                $display("PASS");
                $display("  Outputs: anodes=%h, segs=%h",
                         anodes, segs);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: anodes=%h, segs=%h",
                         expected_anodes, expected_segs);
                $display("  Got:      anodes=%h, segs=%h",
                         anodes, segs);
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
