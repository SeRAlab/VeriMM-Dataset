`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] ascii;
    wire [7:0] seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ascii(ascii),
        .seg(seg)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Letter 'A' (Uppercase)", test_num);
            ascii = 8'h41;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Letter 'a' (Lowercase)", test_num);
            ascii = 8'h61;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Letter 'B' (Uppercase)", test_num);
            ascii = 8'h42;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Letter 'b' (Lowercase)", test_num);
            ascii = 8'h62;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Letter 'C' (Uppercase)", test_num);
            ascii = 8'h43;
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Letter 'c' (Lowercase)", test_num);
            ascii = 8'h63;
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Letter 'D' (Uppercase)", test_num);
            ascii = 8'h44;
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Letter 'd' (Lowercase)", test_num);
            ascii = 8'h64;
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Letter 'E' (Uppercase)", test_num);
            ascii = 8'h45;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Letter 'e' (Lowercase)", test_num);
            ascii = 8'h66;
            ascii = 8'h65;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Testcase %0d: Letter 'F' (Uppercase)", test_num);
            ascii = 8'h46;
            #1;

            check_outputs(8'h20);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Testcase %0d: Letter 'f' (Lowercase)", test_num);
            ascii = 8'h66;
            #1;

            check_outputs(8'h20);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            $display("Testcase %0d: Letter 'G' (Uppercase)", test_num);
            ascii = 8'h47;
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            $display("Testcase %0d: Letter 'g' (Lowercase)", test_num);
            ascii = 8'h67;
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            $display("Testcase %0d: Space Character", test_num);
            ascii = 8'h20;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            $display("Testcase %0d: Invalid Character 'H'", test_num);
            ascii = 8'h48;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase017;

        begin
            test_num = 17;
            $display("Testcase %0d: Null character (Invalid)", test_num);
            ascii = 8'h00;
            #1;

            check_outputs(8'h00);
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
        testcase017();
        
        
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
        input [7:0] expected_seg;
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
