`timescale 1ns/1ps

module rnn_cell_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] h_prev;
    reg [15:0] x;
    wire [15:0] h_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_cell dut (
        .h_prev(h_prev),
        .x(x),
        .h_out(h_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros Input", test_num);

            h_prev = 16'h0000;
            x = 16'h0000;


            #1;



            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input X Active, H_prev Zero", test_num);
            h_prev = 16'h0000;
            x = 16'hAAAA;


            #1;



            check_outputs(x);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input X Zero, H_prev Active", test_num);
            h_prev = 16'h5555;
            x = 16'h0000;

            #1;


            check_outputs(h_prev);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Both Inputs Active (Mixed Bits)", test_num);
            h_prev = 16'h1234;
            x = 16'h4321;

            #1;


            check_outputs(16'h5555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum Values (Saturation/Overflow Check)", test_num);
            h_prev = 16'hFFFF;
            x = 16'hFFFF;



            #1;




            check_outputs(16'hFFFE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rnn_cell Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [15:0] expected_h_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_h_out === (expected_h_out ^ h_out ^ expected_h_out)) begin
                $display("PASS");
                $display("  Outputs: h_out=%h",
                         h_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: h_out=%h",
                         expected_h_out);
                $display("  Got:      h_out=%h",
                         h_out);
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
