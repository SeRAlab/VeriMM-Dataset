`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg idebug;
    reg iwrited;
    reg [13:0] pc;
    reg promdisabled;
    wire [8:0] promaddr;
    wire promenable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .idebug(idebug),
        .iwrited(iwrited),
        .pc(pc),
        .promdisabled(promdisabled),
        .promaddr(promaddr),
        .promenable(promenable)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All enable conditions met (pc=0)", test_num);
            pc = 14'h0000;
            idebug = 1'b0;
            promdisabled = 1'b0;
            iwrited = 1'b0;
            #1;

            check_outputs(9'h000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: All enable conditions met (pc=0x00FF)", test_num);
            pc = 14'h00FF;
            idebug = 1'b0;
            promdisabled = 1'b0;
            iwrited = 1'b0;
            #1;

            check_outputs(9'h0FF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: All enable conditions met (pc=511)", test_num);
            pc = 14'd511;
            idebug = 1'b0;
            promdisabled = 1'b0;
            iwrited = 1'b0;
            #1;

            check_outputs(9'h1FF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: All enable conditions met (pc=1023)", test_num);
            pc = 14'd1023;
            idebug = 1'b0;
            promdisabled = 1'b0;
            iwrited = 1'b0;

            #1;


            check_outputs(9'h1FF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: pc outside 1KB range (pc=1024)", test_num);
            pc = 14'd1024;
            idebug = 1'b0;
            promdisabled = 1'b0;
            iwrited = 1'b0;
            #1;

            check_outputs(9'h000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: idebug HIGH", test_num);
            pc = 14'h0010;
            idebug = 1'b1;
            promdisabled = 1'b0;
            iwrited = 1'b0;
            #1;

            check_outputs(9'h010, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: promdisabled HIGH", test_num);
            pc = 14'h0020;
            idebug = 1'b0;
            promdisabled = 1'b1;
            iwrited = 1'b0;
            #1;

            check_outputs(9'h020, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: iwrited HIGH", test_num);
            pc = 14'h0030;
            idebug = 1'b0;
            promdisabled = 1'b0;
            iwrited = 1'b1;
            #1;

            check_outputs(9'h030, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Multiple signals disabling PROM", test_num);
            pc = 14'h0400;
            idebug = 1'b1;
            promdisabled = 1'b1;
            iwrited = 1'b1;
            #1;

            check_outputs(9'h000, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: High PC address mapping check", test_num);
            pc = 14'h3FFF;
            idebug = 1'b0;
            promdisabled = 1'b0;
            iwrited = 1'b0;

            #1;


            check_outputs(9'h1FF, 1'b0);
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
        input [8:0] expected_promaddr;
        input expected_promenable;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_promaddr === (expected_promaddr ^ promaddr ^ expected_promaddr) &&
                expected_promenable === (expected_promenable ^ promenable ^ expected_promenable)) begin
                $display("PASS");
                $display("  Outputs: promaddr=%h, promenable=%b",
                         promaddr, promenable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: promaddr=%h, promenable=%b",
                         expected_promaddr, expected_promenable);
                $display("  Got:      promaddr=%h, promenable=%b",
                         promaddr, promenable);
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
