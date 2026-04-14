`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] G3;
    reg [15:0] Pr3;
    wire [15:0] G4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .G3(G3),
        .Pr3(Pr3),
        .G4(G4)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: All Zeros", test_num);
        G3 = 16'h0000;
        Pr3 = 16'h0000;

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: All Ones", test_num);
        G3 = 16'hFFFF;
        Pr3 = 16'hFFFF;

        #1;


        check_outputs(16'hFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: G3 High Byte, Pr3 Active", test_num);
        G3 = 16'hFF00;
        Pr3 = 16'hFFFF;


        #1;



        check_outputs(16'hFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: G3 Low Byte, Pr3 Active", test_num);
        G3 = 16'h00FF;
        Pr3 = 16'hFFFF;


        #1;



        check_outputs(16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: G3 active, Pr3 Zero", test_num);
        G3 = 16'h1234;
        Pr3 = 16'h0000;

        #1;


        check_outputs(16'h1234);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Bit Pattern A55A", test_num);
        G3 = 16'hA55A;
        Pr3 = 16'hFFFF;


        #1;



        check_outputs(16'hFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Masked Propagation", test_num);
        G3 = 16'h1234;
        Pr3 = 16'hF0F0;



        #1;




        check_outputs(16'h3234);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Alternating Bits", test_num);
        G3 = 16'hAAAA;
        Pr3 = 16'h5555;



        #1;




        check_outputs(16'hAAAA);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Carry Gen logic check", test_num);
        G3 = 16'h8001;
        Pr3 = 16'h0180;



        #1;




        check_outputs(16'h8181);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Single bit swap", test_num);
        G3 = 16'h0100;
        Pr3 = 16'h0001;



        #1;




        check_outputs(16'h0101);
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
        input [15:0] expected_G4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_G4 === (expected_G4 ^ G4 ^ expected_G4)) begin
                $display("PASS");
                $display("  Outputs: G4=%h",
                         G4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: G4=%h",
                         expected_G4);
                $display("  Got:      G4=%h",
                         G4);
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
