`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cin;
    reg [3:0] g;
    reg [3:0] p;
    wire [3:0] c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cin(cin),
        .g(g),
        .p(p),
        .c(c)
    );
    task testcase001;

    begin
        test_num = 1;
        cin = 1'b0;
        p = 4'b0000;
        g = 4'b0000;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        cin = 1'b1;
        p = 4'b1111;
        g = 4'b0000;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        cin = 1'b1;
        p = 4'b1110;
        g = 4'b0000;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        cin = 1'b0;
        p = 4'b1111;
        g = 4'b0001;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        cin = 1'b0;
        p = 4'b1110;
        g = 4'b0010;
        #1;

        check_outputs(4'b1110);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        cin = 1'b0;
        p = 4'b1011;
        g = 4'b0100;
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        cin = 1'b0;
        p = 4'b0000;
        g = 4'b1111;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        cin = 1'b0;
        p = 4'b1010;
        g = 4'b0101;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        cin = 1'b1;
        p = 4'b0101;
        g = 4'b0000;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        cin = 1'b1;
        p = 4'b1111;
        g = 4'b1111;
        #1;

        check_outputs(4'b1111);
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
        input [3:0] expected_c;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c === (expected_c ^ c ^ expected_c)) begin
                $display("PASS");
                $display("  Outputs: c=%h",
                         c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h",
                         expected_c);
                $display("  Got:      c=%h",
                         c);
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
