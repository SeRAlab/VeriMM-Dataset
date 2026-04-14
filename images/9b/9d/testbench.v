`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] num;
    wire [6:0] display;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .num(num),
        .display(display)
    );
    task testcase001;

    begin
        test_num = 1;
        num = 4'h0;
        $display("Test %0d: num = %h (Display 0)", test_num, num);
        #1;

        check_outputs(7'h3f);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        num = 4'h1;
        $display("Test %0d: num = %h (Display 1)", test_num, num);
        #1;

        check_outputs(7'h06);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        num = 4'h2;
        $display("Test %0d: num = %h (Display 2)", test_num, num);
        #1;

        check_outputs(7'h5b);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        num = 4'h3;
        $display("Test %0d: num = %h (Display 3)", test_num, num);
        #1;

        check_outputs(7'h4f);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        num = 4'h4;
        $display("Test %0d: num = %h (Display 4)", test_num, num);
        #1;

        check_outputs(7'h66);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        num = 4'h5;
        $display("Test %0d: num = %h (Display 5)", test_num, num);
        #1;

        check_outputs(7'h6d);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        num = 4'h6;
        $display("Test %0d: num = %h (Display 6)", test_num, num);
        #1;

        check_outputs(7'h7d);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        num = 4'h7;
        $display("Test %0d: num = %h (Display 7)", test_num, num);
        #1;

        check_outputs(7'h07);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        num = 4'h8;
        $display("Test %0d: num = %h (Display 8)", test_num, num);
        #1;

        check_outputs(7'h7f);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        num = 4'h9;
        $display("Test %0d: num = %h (Display 9)", test_num, num);
        #1;

        check_outputs(7'h6f);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        num = 4'ha;
        $display("Test %0d: num = %h (Display A)", test_num, num);
        #1;

        check_outputs(7'h77);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        num = 4'hb;
        $display("Test %0d: num = %h (Display b)", test_num, num);
        #1;

        check_outputs(7'h7c);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        num = 4'hc;
        $display("Test %0d: num = %h (Display C)", test_num, num);
        #1;

        check_outputs(7'h39);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        num = 4'hd;
        $display("Test %0d: num = %h (Display d)", test_num, num);
        #1;

        check_outputs(7'h5e);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        num = 4'he;
        $display("Test %0d: num = %h (Display E)", test_num, num);
        #1;

        check_outputs(7'h79);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        num = 4'hf;
        $display("Test %0d: num = %h (Display F)", test_num, num);
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
        input [6:0] expected_display;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_display === (expected_display ^ display ^ expected_display)) begin
                $display("PASS");
                $display("  Outputs: display=%h",
                         display);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: display=%h",
                         expected_display);
                $display("  Got:      display=%h",
                         display);
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
