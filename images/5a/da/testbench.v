`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] IN0;
    reg [4:0] R1;
    reg [4:0] R2;
    reg RE1;
    reg RE2;
    reg [4:0] W;
    reg WE;
    wire [31:0] OUT1;
    wire [31:0] OUT2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IN0(IN0),
        .R1(R1),
        .R2(R2),
        .RE1(RE1),
        .RE2(RE2),
        .W(W),
        .WE(WE),
        .OUT1(OUT1),
        .OUT2(OUT2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write to Reg 1 and Read from Port 1", test_num);

            IN0 = 0; W = 0; WE = 0; R1 = 0; R2 = 0; RE1 = 0; RE2 = 0;
            #10;


            IN0 = 32'h12345678;
            W = 5'd1;
            WE = 1;
            #10;
            WE = 0;


            R1 = 5'd1;
            RE1 = 1;
            #10;

            #1;


            check_outputs(32'h12345678, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write to Reg 31 and Read from Port 2", test_num);

            IN0 = 0; W = 0; WE = 0; R1 = 0; R2 = 0; RE1 = 0; RE2 = 0;
            #10;


            IN0 = 32'hAAAAAAAA;
            W = 5'd31;
            WE = 1;
            #10;
            WE = 0;


            R2 = 5'd31;
            RE2 = 1;
            #10;

            #1;


            check_outputs(32'h0, 32'hAAAAAAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simultaneous Read from Port 1 and Port 2", test_num);

            IN0 = 0; W = 0; WE = 0; R1 = 0; R2 = 0; RE1 = 0; RE2 = 0;
            #10;


            IN0 = 32'h55555555;
            W = 5'd5;
            WE = 1;
            #10;


            IN0 = 32'h10101010;
            W = 5'd10;
            WE = 1;
            #10;
            WE = 0;


            R1 = 5'd5;
            RE1 = 1;
            R2 = 5'd10;
            RE2 = 1;
            #10;

            #1;


            check_outputs(32'h55555555, 32'h10101010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify WE (Write Enable) Functionality", test_num);

            IN0 = 0; W = 0; WE = 0; R1 = 0; R2 = 0; RE1 = 0; RE2 = 0;
            #10;


            IN0 = 32'hFEEDFEED;
            W = 5'd15;
            WE = 1;
            #10;


            IN0 = 32'hBAD0BAD0;
            W = 5'd15;
            WE = 0;
            #10;


            R1 = 5'd15;
            RE1 = 1;
            #10;

            #1;


            check_outputs(32'hFEEDFEED, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify RE (Read Enable) Functionality", test_num);

            IN0 = 0; W = 0; WE = 0; R1 = 0; R2 = 0; RE1 = 0; RE2 = 0;
            #10;


            IN0 = 32'h20202020;
            W = 5'd20;
            WE = 1;
            #10;
            WE = 0;


            R1 = 5'd20;
            RE1 = 0;
            R2 = 5'd20;
            RE2 = 0;
            #10;

            #1;


            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overwriting a Register", test_num);

            IN0 = 0; W = 0; WE = 0; R1 = 0; R2 = 0; RE1 = 0; RE2 = 0;
            #10;


            IN0 = 32'h11111111;
            W = 5'd7;
            WE = 1;
            #10;


            IN0 = 32'h22222222;
            W = 5'd7;
            WE = 1;
            #10;
            WE = 0;


            R1 = 5'd7;
            RE1 = 1;
            #10;

            #1;


            check_outputs(32'h22222222, 32'h0);
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
        input [31:0] expected_OUT1;
        input [31:0] expected_OUT2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUT1 === (expected_OUT1 ^ OUT1 ^ expected_OUT1) &&
                expected_OUT2 === (expected_OUT2 ^ OUT2 ^ expected_OUT2)) begin
                $display("PASS");
                $display("  Outputs: OUT1=%h, OUT2=%h",
                         OUT1, OUT2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT1=%h, OUT2=%h",
                         expected_OUT1, expected_OUT2);
                $display("  Got:      OUT1=%h, OUT2=%h",
                         OUT1, OUT2);
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
