`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] hex_i;
    wire [6:0] hex_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .hex_i(hex_i),
        .hex_o(hex_o)
    );
    task testcase001;

        begin
            test_num = 1;
            hex_i = 4'h0;
            $display("Test %0d: Input hex_i = %h", test_num, hex_i);
            #1;

            check_outputs(7'h3f);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            hex_i = 4'h1;
            $display("Test %0d: Input hex_i = %h", test_num, hex_i);
            #1;

            check_outputs(7'h06);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            hex_i = 4'h2;
            $display("Test %0d: Input hex_i = %h", test_num, hex_i);
            #1;

            check_outputs(7'h5b);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            hex_i = 4'h3;
            $display("Test %0d: Input hex_i = %h", test_num, hex_i);
            #1;

            check_outputs(7'h4f);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            hex_i = 4'h4;
            $display("Test %0d: Input hex_i = %h", test_num, hex_i);
            #1;

            check_outputs(7'h66);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            hex_i = 4'h5;
            $display("Test %0d: Input hex_i = %h", test_num, hex_i);
            #1;

            check_outputs(7'h6d);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            hex_i = 4'h6;
            $display("Test %0d: Input hex_i = %h", test_num, hex_i);
            #1;

            check_outputs(7'h7d);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            hex_i = 4'h7;
            $display("Test %0d: Input hex_i = %h", test_num, hex_i);
            #1;

            check_outputs(7'h07);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            hex_i = 4'h8;
            $display("Test %0d: Input hex_i = %h", test_num, hex_i);
            #1;

            check_outputs(7'h7f);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            hex_i = 4'h9;
            $display("Test %0d: Input hex_i = %h", test_num, hex_i);
            #1;

            check_outputs(7'h6f);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            hex_i = 4'hA;
            $display("Test %0d: Input hex_i = %h", test_num, hex_i);
            #1;

            check_outputs(7'h77);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            hex_i = 4'hB;
            $display("Test %0d: Input hex_i = %h", test_num, hex_i);
            #1;

            check_outputs(7'h7c);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            hex_i = 4'hC;
            $display("Test %0d: Input hex_i = %h", test_num, hex_i);
            #1;

            check_outputs(7'h39);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            hex_i = 4'hD;
            $display("Test %0d: Input hex_i = %h", test_num, hex_i);
            #1;

            check_outputs(7'h5e);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            hex_i = 4'hE;
            $display("Test %0d: Input hex_i = %h", test_num, hex_i);
            #1;

            check_outputs(7'h79);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            hex_i = 4'hF;
            $display("Test %0d: Input hex_i = %h", test_num, hex_i);
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
        input [6:0] expected_hex_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hex_o === (expected_hex_o ^ hex_o ^ expected_hex_o)) begin
                $display("PASS");
                $display("  Outputs: hex_o=%h",
                         hex_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hex_o=%h",
                         expected_hex_o);
                $display("  Got:      hex_o=%h",
                         hex_o);
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
