`timescale 1ns/1ps

module round_sat_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] max_val;
    reg [15:0] min_val;
    reg [15:0] signal;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    round_sat dut (
        .max_val(max_val),
        .min_val(min_val),
        .signal(signal),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Signal above max_val", test_num);
            max_val = 16'd1000;
            min_val = 16'd100;
            signal  = 16'd1500;

            #1;


            check_outputs(16'd1000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Signal below min_val", test_num);
            max_val = 16'd1000;
            min_val = 16'd100;
            signal  = 16'd50;

            #1;


            check_outputs(16'd100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Signal within range (nominal)", test_num);
            max_val = 16'd1000;
            min_val = 16'd100;
            signal  = 16'd550;

            #1;


            check_outputs(16'd550);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Signal exactly at max_val boundary", test_num);
            max_val = 16'd5000;
            min_val = 16'd0;
            signal  = 16'd5000;

            #1;


            check_outputs(16'd5000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Signal exactly at min_val boundary", test_num);
            max_val = 16'd5000;
            min_val = 16'd10;
            signal  = 16'd10;

            #1;


            check_outputs(16'd10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Large values and narrow range", test_num);
            max_val = 16'hFFFF;
            min_val = 16'hFFFE;
            signal  = 16'hF000;

            #1;


            check_outputs(16'hFFFE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Max and Min are equal, signal higher", test_num);
            max_val = 16'd200;
            min_val = 16'd200;
            signal  = 16'd300;

            #1;


            check_outputs(16'd200);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("round_sat Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
