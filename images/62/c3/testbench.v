`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg sel;
    reg [8:0] vote;
    wire pass;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .sel(sel),
        .vote(vote),
        .pass(pass)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: sel=0, 0 votes (Threshold > 3)", test_num);
            sel = 0;
            vote = 9'b000000000;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: sel=0, 3 votes (Threshold > 3 - Boundary)", test_num);
            sel = 0;
            vote = 9'b000000111;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: sel=0, 4 votes (Threshold > 3 - Boundary Pass)", test_num);
            sel = 0;
            vote = 9'b000001111;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: sel=0, 9 votes (Max votes)", test_num);
            sel = 0;
            vote = 9'b111111111;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: sel=1, 0 votes (Threshold > 6)", test_num);
            sel = 1;
            vote = 9'b000000000;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: sel=1, 6 votes (Threshold > 6 - Boundary)", test_num);
            sel = 1;
            vote = 9'b001111111;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: sel=1, 7 votes (Threshold > 6 - Boundary Pass)", test_num);
            sel = 1;
            vote = 9'b011111111;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: sel=1, 9 votes (Max votes)", test_num);
            sel = 1;
            vote = 9'b111111111;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: sel=0, Dispersed 5 votes (Pass)", test_num);
            sel = 0;
            vote = 9'b101010101;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: sel=1, Dispersed 5 votes (Fail)", test_num);
            sel = 1;
            vote = 9'b101010101;
            #1;

            check_outputs(0);
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
        input expected_pass;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pass === (expected_pass ^ pass ^ expected_pass)) begin
                $display("PASS");
                $display("  Outputs: pass=%b",
                         pass);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pass=%b",
                         expected_pass);
                $display("  Got:      pass=%b",
                         pass);
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
