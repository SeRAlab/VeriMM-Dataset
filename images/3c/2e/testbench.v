`timescale 1ns/1ps

module SRAM_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] D;
    reg RE;
    reg WE;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM dut (
        .A(A),
        .D(D),
        .RE(RE),
        .WE(WE),
        .Q(Q)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Simple Write and Read at Address 0x01", test_num);

        WE = 1; RE = 0; A = 8'h01; D = 8'hA5;
        #10;

        WE = 0; RE = 1; A = 8'h01;
        #10;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write and Read at Address 0xFF", test_num);

        WE = 1; RE = 0; A = 8'hFF; D = 8'h5A;
        #10;

        WE = 0; RE = 1; A = 8'hFF;
        #10;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiple writes and verify data persistence", test_num);

        WE = 1; RE = 0; A = 8'h10; D = 8'h11; #10;

        WE = 1; RE = 0; A = 8'h20; D = 8'h22; #10;

        WE = 1; RE = 0; A = 8'h30; D = 8'h33; #10;


        WE = 0; RE = 1; A = 8'h10; #10;
        #1;

        check_outputs(8'h11);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify data does not change when WE is low", test_num);

        WE = 1; RE = 0; A = 8'h40; D = 8'hCC; #10;

        WE = 0; RE = 0; A = 8'h40; D = 8'hDD; #10;

        WE = 0; RE = 1; A = 8'h40; #10;
        #1;

        check_outputs(8'hCC);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Overwrite an existing address", test_num);

        WE = 1; RE = 0; A = 8'h50; D = 8'h12; #10;

        WE = 1; RE = 0; A = 8'h50; D = 8'h34; #10;

        WE = 0; RE = 1; A = 8'h50; #10;
        #1;

        check_outputs(8'h34);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Check memory isolation (Read different address)", test_num);

        WE = 1; RE = 0; A = 8'h60; D = 8'hAA; #10;

        WE = 1; RE = 0; A = 8'h61; D = 8'hBB; #10;

        WE = 0; RE = 1; A = 8'h61; #10;
        #1;

        check_outputs(8'hBB);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM Testbench");
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
        input [7:0] expected_Q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
