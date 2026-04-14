`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] P1X;
    reg [11:0] P1Y;
    reg [11:0] P2X;
    reg [11:0] P2Y;
    reg [11:0] PTX;
    reg [11:0] PTY;
    wire sin;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .P1X(P1X),
        .P1Y(P1Y),
        .P2X(P2X),
        .P2Y(P2Y),
        .PTX(PTX),
        .PTY(PTY),
        .sin(sin)
    );
    task testcase001;

    begin
        test_num = 1;

        P1X = 12'd10; P1Y = 12'd10;
        P2X = 12'd20; P2Y = 12'd10;
        PTX = 12'd15; PTY = 12'd20;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;

        P1X = 12'd10; P1Y = 12'd10;
        P2X = 12'd20; P2Y = 12'd10;
        PTX = 12'd15; PTY = 12'd5;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;

        P1X = 12'd10; P1Y = 12'd10;
        P2X = 12'd30; P2Y = 12'd10;
        PTX = 12'd20; PTY = 12'd10;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;

        P1X = 12'd10; P1Y = 12'd10;
        P2X = 12'd10; P2Y = 12'd30;
        PTX = 12'd10; PTY = 12'd20;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;

        P1X = 12'd10; P1Y = 12'd10;
        P2X = 12'd30; P2Y = 12'd30;
        PTX = 12'd20; PTY = 12'd20;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;

        P1X = 12'd100; P1Y = 12'd100;
        P2X = 12'd200; P2Y = 12'd200;
        PTX = 12'd100; PTY = 12'd100;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;

        P1X = 12'd100; P1Y = 12'd100;
        P2X = 12'd200; P2Y = 12'd200;
        PTX = 12'd200; PTY = 12'd200;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;

        P1X = 12'd0;    P1Y = 12'd0;
        P2X = 12'd4095; P2Y = 12'd1;
        PTX = 12'd1;    PTY = 12'd4095;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;

        P1X = 12'd0;    P1Y = 12'd0;
        P2X = 12'd1;    P2Y = 12'd4095;
        PTX = 12'd4095; PTY = 12'd1;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;


        P1X = 12'd20; P1Y = 12'd20;
        P2X = 12'd10; P2Y = 12'd20;
        PTX = 12'd15; PTY = 12'd15;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;

        P1X = 12'd20; P1Y = 12'd20;
        P2X = 12'd10; P2Y = 12'd20;
        PTX = 12'd15; PTY = 12'd25;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;

        P1X = 12'd100; P1Y = 12'd100;
        P2X = 12'd100; P2Y = 12'd200;
        PTX = 12'd50;  PTY = 12'd150;

        #1;


        check_outputs(1'b1);
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
        input expected_sin;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sin === (expected_sin ^ sin ^ expected_sin)) begin
                $display("PASS");
                $display("  Outputs: sin=%b",
                         sin);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sin=%b",
                         expected_sin);
                $display("  Got:      sin=%b",
                         sin);
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
