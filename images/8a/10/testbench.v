`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] ain;
    reg [15:0] bin;
    wire [15:0] addout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ain(ain),
        .bin(bin),
        .addout(addout)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Zero addition", test_num);
        ain = 16'h0000;
        bin = 16'h0000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Simple addition", test_num);
        ain = 16'h0001;
        bin = 16'h0001;
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Addition with zero", test_num);
        ain = 16'hABCD;
        bin = 16'h0000;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Maximum boundary wrap-around", test_num);
        ain = 16'hFFFF;
        bin = 16'h0001;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Alternating bits", test_num);
        ain = 16'hAAAA;
        bin = 16'h5555;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Sign bit carry-over", test_num);
        ain = 16'h7FFF;
        bin = 16'h0001;
        #1;

        check_outputs(16'h8000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Double maximum values", test_num);
        ain = 16'hFFFF;
        bin = 16'hFFFF;
        #1;

        check_outputs(16'hFFFE);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Half-scale addition", test_num);
        ain = 16'h8000;
        bin = 16'h8000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Random hex pattern 1", test_num);
        ain = 16'h1234;
        bin = 16'h5678;
        #1;

        check_outputs(16'h68AC);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Random hex pattern 2", test_num);
        ain = 16'hC0DE;
        bin = 16'hDEAD;
        #1;

        check_outputs(16'h9F8B);
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
        input [15:0] expected_addout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_addout === (expected_addout ^ addout ^ expected_addout)) begin
                $display("PASS");
                $display("  Outputs: addout=%h",
                         addout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addout=%h",
                         expected_addout);
                $display("  Got:      addout=%h",
                         addout);
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
