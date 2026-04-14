`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] digit;
    reg [1:0] sel;
    wire [3:0] anode;
    wire [6:0] cathode;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .digit(digit),
        .sel(sel),
        .anode(anode),
        .cathode(cathode)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Digit 0, Selector 0", test_num);
            digit = 4'h0;
            sel = 2'h0;

            #1;


            check_outputs(4'hE, 7'h40);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Digit 1, Selector 1", test_num);
            digit = 4'h1;
            sel = 2'h1;

            #1;


            check_outputs(4'hD, 7'h79);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Digit 2, Selector 2", test_num);
            digit = 4'h2;
            sel = 2'h2;

            #1;


            check_outputs(4'hB, 7'h24);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Digit 3, Selector 3", test_num);
            digit = 4'h3;
            sel = 2'h3;

            #1;


            check_outputs(4'h7, 7'h30);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Digit 8 (All segments), Selector 0", test_num);
            digit = 4'h8;
            sel = 2'h0;

            #1;


            check_outputs(4'hE, 7'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Digit A (Hex), Selector 1", test_num);
            digit = 4'hA;
            sel = 2'h1;

            #1;


            check_outputs(4'hD, 7'h08);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Digit F (Hex), Selector 3", test_num);
            digit = 4'hF;
            sel = 2'h3;

            #1;


            check_outputs(4'h7, 7'h0E);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Digit 7, Selector 2", test_num);
            digit = 4'h7;
            sel = 2'h2;

            #1;


            check_outputs(4'hB, 7'h78);
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
        input [3:0] expected_anode;
        input [6:0] expected_cathode;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_anode === (expected_anode ^ anode ^ expected_anode) &&
                expected_cathode === (expected_cathode ^ cathode ^ expected_cathode)) begin
                $display("PASS");
                $display("  Outputs: anode=%h, cathode=%h",
                         anode, cathode);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: anode=%h, cathode=%h",
                         expected_anode, expected_cathode);
                $display("  Got:      anode=%h, cathode=%h",
                         anode, cathode);
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
