`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [31:0] i_pc;
    reg [31:0] outside_pc;
    reg pcWre;
    reg reset;
    wire [31:0] o_pc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .i_pc(i_pc),
        .outside_pc(outside_pc),
        .pcWre(pcWre),
        .reset(reset),
        .o_pc(o_pc)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset to outside_pc", test_num);

            outside_pc = 32'h0000_1000;
            i_pc = 32'h0000_2000;
            pcWre = 0;


            reset = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h0000_1000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Update PC when pcWre is high", test_num);

            reset = 1;
            outside_pc = 32'h0000_0000;
            @(posedge clk);


            #1;
            reset = 0;
            pcWre = 1;
            i_pc = 32'h1234_5678;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Hold current value when pcWre is low", test_num);

            reset = 1;
            outside_pc = 32'hAAAA_BBBB;
            @(posedge clk);


            #1;
            reset = 0;
            pcWre = 0;
            i_pc = 32'hFFFF_FFFF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hAAAA_BBBB);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Reset priority over pcWre", test_num);

            reset = 1;
            outside_pc = 32'hDEAD_BEEF;
            pcWre = 1;
            i_pc = 32'h0000_0001;
            @(posedge clk);
            #2;


            #1;



            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Sequential Program Flow", test_num);

            reset = 1;
            outside_pc = 32'h0000_0000;
            @(posedge clk);


            #1;
            reset = 0;
            pcWre = 1;
            i_pc = 32'h0000_0004;
            @(posedge clk);


            #1;
            i_pc = 32'h0000_0008;
            @(posedge clk);


            #1;
            i_pc = 32'h0000_000C;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h0000_000C);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Mid-stream Reset", test_num);

            reset = 1;
            outside_pc = 32'h0;
            @(posedge clk);


            #1;
            reset = 0;
            pcWre = 1;
            i_pc = 32'hCAFE_BABE;
            @(posedge clk);


            #1;
            reset = 1;
            outside_pc = 32'h5555_6666;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h5555_6666);
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
        input [31:0] expected_o_pc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_pc === (expected_o_pc ^ o_pc ^ expected_o_pc)) begin
                $display("PASS");
                $display("  Outputs: o_pc=%h",
                         o_pc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_pc=%h",
                         expected_o_pc);
                $display("  Got:      o_pc=%h",
                         o_pc);
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
