`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg IRL;
    reg Mode;
    reg [1:0] y;
    wire [1:0] X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IRL(IRL),
        .Mode(Mode),
        .y(y),
        .X(X)
    );
    task testcase001;

    begin
        test_num = 1; Mode = 0; IRL = 0; y = 2'b00;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase002;

    begin
        test_num = 2; Mode = 0; IRL = 0; y = 2'b01;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3; Mode = 0; IRL = 0; y = 2'b10;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase004;

    begin
        test_num = 4; Mode = 0; IRL = 0; y = 2'b11;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5; Mode = 0; IRL = 1; y = 2'b00;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase006;

    begin
        test_num = 6; Mode = 0; IRL = 1; y = 2'b01;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase007;

    begin
        test_num = 7; Mode = 0; IRL = 1; y = 2'b10;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase008;

    begin
        test_num = 8; Mode = 0; IRL = 1; y = 2'b11;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase009;

    begin
        test_num = 9; Mode = 1; IRL = 0; y = 2'b00;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase010;

    begin
        test_num = 10; Mode = 1; IRL = 0; y = 2'b01;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase011;

    begin
        test_num = 11; Mode = 1; IRL = 0; y = 2'b10;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase012;

    begin
        test_num = 12; Mode = 1; IRL = 0; y = 2'b11;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase013;

    begin
        test_num = 13; Mode = 1; IRL = 1; y = 2'b00;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase014;

    begin
        test_num = 14; Mode = 1; IRL = 1; y = 2'b01;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase015;

    begin
        test_num = 15; Mode = 1; IRL = 1; y = 2'b10;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase016;

    begin
        test_num = 16; Mode = 1; IRL = 1; y = 2'b11;
        #1;

        check_outputs(2'b10);
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
        input [1:0] expected_X;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_X === (expected_X ^ X ^ expected_X)) begin
                $display("PASS");
                $display("  Outputs: X=%h",
                         X);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%h",
                         expected_X);
                $display("  Got:      X=%h",
                         X);
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
