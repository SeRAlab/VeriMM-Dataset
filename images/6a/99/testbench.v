`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] ADDR_bus_in;
    reg [19:0] CNTRL_bus_in;
    reg [15:0] DATA_bus_in;
    wire [3:0] FLAG_bus_out;
    wire [15:0] FU_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADDR_bus_in(ADDR_bus_in),
        .CNTRL_bus_in(CNTRL_bus_in),
        .DATA_bus_in(DATA_bus_in),
        .FLAG_bus_out(FLAG_bus_out),
        .FU_out(FU_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Addition", test_num);
            ADDR_bus_in = 16'h0010;
            DATA_bus_in = 16'h0020;
            CNTRL_bus_in = 20'h00000;

            #1;


            check_outputs(4'h0, 16'h0030);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (Zero Result)", test_num);
            ADDR_bus_in = 16'hFFFF;
            DATA_bus_in = 16'hFFFF;
            CNTRL_bus_in = 20'h00001;

            #1;


            check_outputs(4'h4, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND", test_num);
            ADDR_bus_in = 16'hAAAA;
            DATA_bus_in = 16'hF0F0;
            CNTRL_bus_in = 20'h00002;

            #1;


            check_outputs(4'h0, 16'hA0A0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise OR", test_num);
            ADDR_bus_in = 16'h1234;
            DATA_bus_in = 16'h8765;
            CNTRL_bus_in = 20'h00003;

            #1;


            check_outputs(4'h8, 16'h9775);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise XOR", test_num);
            ADDR_bus_in = 16'h5555;
            DATA_bus_in = 16'hFFFF;
            CNTRL_bus_in = 20'h00004;

            #1;


            check_outputs(4'h0, 16'hAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Carry Out Check", test_num);
            ADDR_bus_in = 16'h8000;
            DATA_bus_in = 16'h8000;
            CNTRL_bus_in = 20'h00000;

            #1;


            check_outputs(4'h3, 16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Pass-through ADDR", test_num);
            ADDR_bus_in = 16'hABCD;
            DATA_bus_in = 16'h0000;
            CNTRL_bus_in = 20'h00005;
            #1;

            check_outputs(4'h0, 16'hABCD);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Pass-through DATA", test_num);
            ADDR_bus_in = 16'h0000;
            DATA_bus_in = 16'hDEAF;
            CNTRL_bus_in = 20'h00006;
            #1;

            check_outputs(4'h0, 16'hDEAF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Increment Operation", test_num);
            ADDR_bus_in = 16'h00FE;
            DATA_bus_in = 16'hXXXX;
            CNTRL_bus_in = 20'h00007;
            #1;

            check_outputs(4'h0, 16'h00FF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Bits High Operation", test_num);
            ADDR_bus_in = 16'hFFFF;
            DATA_bus_in = 16'hFFFF;
            CNTRL_bus_in = 20'hFFFFF;

            #1;


            check_outputs(4'hF, 16'hFFFF);
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
        input [3:0] expected_FLAG_bus_out;
        input [15:0] expected_FU_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_FLAG_bus_out === (expected_FLAG_bus_out ^ FLAG_bus_out ^ expected_FLAG_bus_out) &&
                expected_FU_out === (expected_FU_out ^ FU_out ^ expected_FU_out)) begin
                $display("PASS");
                $display("  Outputs: FLAG_bus_out=%h, FU_out=%h",
                         FLAG_bus_out, FU_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: FLAG_bus_out=%h, FU_out=%h",
                         expected_FLAG_bus_out, expected_FU_out);
                $display("  Got:      FLAG_bus_out=%h, FU_out=%h",
                         FLAG_bus_out, FU_out);
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
