`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg select;
    wire [6:0] b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .select(select),
        .b(b)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 4'h0;
        select = 0;
        #10;
        #1;

        check_outputs(7'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 4'h1;
        select = 0;
        #10;
        #1;

        check_outputs(7'h07);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 4'h2;
        select = 0;
        #10;
        #1;

        check_outputs(7'h19);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 4'h4;
        select = 0;
        #10;
        #1;

        check_outputs(7'h2A);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 4'h8;
        select = 0;
        #10;
        #1;

        check_outputs(7'h4B);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 4'h3;
        select = 0;
        #10;
        #1;

        check_outputs(7'h1E);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 4'hF;
        select = 0;
        #10;
        #1;

        check_outputs(7'h7F);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 4'h0;
        select = 1;
        #10;
        #1;

        check_outputs(7'h7F);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 4'hF;
        select = 1;
        #10;
        #1;

        check_outputs(7'h00);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 4'hA;
        select = 0;
        #10;
        #1;

        check_outputs(7'h52);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        a = 4'h5;
        select = 1;
        #10;

        #1;


        check_outputs(7'h52);
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
        input [6:0] expected_b;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_b === (expected_b ^ b ^ expected_b)) begin
                $display("PASS");
                $display("  Outputs: b=%h",
                         b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b=%h",
                         expected_b);
                $display("  Got:      b=%h",
                         b);
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
