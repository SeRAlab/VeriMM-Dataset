`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] b;
    reg [63:0] cin;
    wire [63:0] cout;
    wire [63:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .b(b),
        .cin(cin),
        .cout(cout),
        .s(s)
    );
    task testcase001;

    begin
        test_num = 1;
        cin = 64'd0;
        b = 64'd0;


        #1;



        check_outputs(64'h0, 64'h4);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        cin = 64'h4;
        b = 64'h0;


        #1;



        check_outputs(64'h4, 64'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        cin = 64'h4;
        b = 64'h4;


        #1;



        check_outputs(64'h4, 64'h4);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        cin = 64'hFFFFFFFFFFFFFFFF;
        b = 64'h0;


        #1;



        check_outputs(64'h4, 64'hFFFFFFFFFFFFFFFB);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        cin = 64'hFFFFFFFFFFFFFFFF;
        b = 64'hFFFFFFFFFFFFFFFF;


        #1;



        check_outputs(64'hFFFFFFFFFFFFFFFF, 64'h4);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        cin = 64'hA;
        b = 64'h6;



        #1;




        check_outputs(64'h6, 64'h8);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        cin = 64'h5555555555555555;
        b = 64'hAAAAAAAAAAAAAAAA;


        #1;



        check_outputs(64'h4, 64'hFFFFFFFFFFFFFFFB);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        cin = 64'h1;
        b = 64'h2;


        #1;



        check_outputs(64'h0, 64'h7);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        cin = 64'h8000000000000000;
        b = 64'h8000000000000000;


        #1;



        check_outputs(64'h8000000000000000, 64'h4);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        cin = 64'h123456789ABCDEF0;
        b = 64'h0FEDCBA987654321;

        #1;


        check_outputs(64'h0204422882044220, 64'h1DD99D211DD99DD5);
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
        input [63:0] expected_cout;
        input [63:0] expected_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: cout=%h, s=%h",
                         cout, s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%h, s=%h",
                         expected_cout, expected_s);
                $display("  Got:      cout=%h, s=%h",
                         cout, s);
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
