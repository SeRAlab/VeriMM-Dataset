`timescale 1ns/1ps

module SRAM_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] D;
    reg RE;
    reg WE;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_4bit dut (
        .D(D),
        .RE(RE),
        .WE(WE),
        .Q(Q)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Write pattern 4'hA and Read back", test_num);

        WE = 1; RE = 1; D = 4'h0;
        #10;

        WE = 0; D = 4'hA;
        #10;

        WE = 1; RE = 0;
        #10;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Write pattern 4'h5 and Read back", test_num);

        WE = 0; D = 4'h5; RE = 1;
        #10;

        WE = 1; RE = 0;
        #10;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Write pattern 4'hF (all ones) and Read back", test_num);

        WE = 0; D = 4'hF; RE = 1;
        #10;

        WE = 1; RE = 0;
        #10;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Write pattern 4'h0 (all zeros) and Read back", test_num);

        WE = 0; D = 4'h0; RE = 1;
        #10;

        WE = 1; RE = 0;
        #10;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Data retention check (Disable WE, change D, check Q)", test_num);

        WE = 0; D = 4'h7; RE = 1;
        #10;

        WE = 1; D = 4'hE;
        #10;

        RE = 0;
        #10;
        #1;

        check_outputs(4'h7);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Overwrite check (Write 4'hB, then Write 4'h2, Read back)", test_num);

        WE = 0; D = 4'hB; RE = 1;
        #10;

        WE = 0; D = 4'h2;
        #10;

        WE = 1; RE = 0;
        #10;
        #1;

        check_outputs(4'h2);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_4bit Testbench");
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
        input [3:0] expected_Q;
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
