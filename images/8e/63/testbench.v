`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [47:0] MRESULT;
    reg [1:0] NZEXP;
    reg [31:0] SRC1;
    reg [31:0] SRC2;
    wire [36:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .MRESULT(MRESULT),
        .NZEXP(NZEXP),
        .SRC1(SRC1),
        .SRC2(SRC2),
        .OUT(OUT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 1.0 * 1.0", test_num);
            SRC1 = 32'h3F800000;
            SRC2 = 32'h3F800000;
            MRESULT = 48'h400000000000;
            NZEXP = 2'b11;
            #1;

            check_outputs(37'h07F8000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: -2.0 * 4.0", test_num);
            SRC1 = 32'hC0000000;
            SRC2 = 32'h40800000;
            MRESULT = 48'h400000000000;
            NZEXP = 2'b11;

            #1;


            check_outputs(37'h1828000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 1.5 * 1.5 (Normalization Shift)", test_num);
            SRC1 = 32'h3FC00000;
            SRC2 = 32'h3FC00000;
            MRESULT = 48'h900000000000;
            NZEXP = 2'b11;

            #1;


            check_outputs(37'h0809000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 1.0 * 0.0 (Zero check)", test_num);
            SRC1 = 32'h3F800000;
            SRC2 = 32'h00000000;
            MRESULT = 48'h000000000000;
            NZEXP = 2'b10;
            #1;

            check_outputs(37'h0000000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 2.0 * 0.5", test_num);
            SRC1 = 32'h40000000;
            SRC2 = 32'h3F000000;
            MRESULT = 48'h400000000000;
            NZEXP = 2'b11;

            #1;


            check_outputs(37'h07F8000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: -1.25 * -2.0", test_num);
            SRC1 = 32'hBFA00000;
            SRC2 = 32'hC0000000;
            MRESULT = 48'h500000000000;
            NZEXP = 2'b11;

            #1;


            check_outputs(37'h080A000000);
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
        input [36:0] expected_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: OUT=%h",
                         OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%h",
                         expected_OUT);
                $display("  Got:      OUT=%h",
                         OUT);
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
