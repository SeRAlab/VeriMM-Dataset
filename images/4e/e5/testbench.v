`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] Xin;
    reg [2:0] Yin;
    wire [2:0] cout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Xin(Xin),
        .Yin(Yin),
        .cout(cout)
    );
    task testcase001;

    begin
        test_num = 1;
        Xin = 3'b000; Yin = 3'b000;
        $display("Test %0d: All Zeros", test_num);
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        Xin = 3'b111; Yin = 3'b000;
        $display("Test %0d: Xin Three-in-a-row", test_num);

        #1;


        check_outputs(3'b001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        Xin = 3'b000; Yin = 3'b111;
        $display("Test %0d: Yin Three-in-a-row", test_num);

        #1;


        check_outputs(3'b010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        Xin = 3'b111; Yin = 3'b111;
        $display("Test %0d: Both Three-in-a-row with Overlap", test_num);

        #1;


        check_outputs(3'b111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        Xin = 3'b101; Yin = 3'b010;
        $display("Test %0d: Interleaved patterns (No win, No overlap)", test_num);
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        Xin = 3'b110; Yin = 3'b011;
        $display("Test %0d: Partial patterns with Overlap (bit 1)", test_num);

        #1;


        check_outputs(3'b100);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        Xin = 3'b001; Yin = 3'b001;
        $display("Test %0d: Single bit Overlap (bit 0)", test_num);

        #1;


        check_outputs(3'b100);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        Xin = 3'b101; Yin = 3'b111;
        $display("Test %0d: Yin Win with specific Xin combination", test_num);

        #1;


        check_outputs(3'b110);
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
        input [2:0] expected_cout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout)) begin
                $display("PASS");
                $display("  Outputs: cout=%h",
                         cout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%h",
                         expected_cout);
                $display("  Got:      cout=%h",
                         cout);
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
