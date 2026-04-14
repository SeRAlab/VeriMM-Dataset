`timescale 1ns/1ps

module mClkBuf_tb;

    // Testbench signals (combinational circuit)
    reg i_Clk;
    wire o_Clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mClkBuf dut (
        .i_Clk(i_Clk),
        .o_Clk(o_Clk)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Drive input low", test_num);
            i_Clk = 1'b0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Drive input high", test_num);
            i_Clk = 1'b1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Toggle transition 0 to 1", test_num);
            i_Clk = 1'b0;
            #5;
            i_Clk = 1'b1;
            #5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Toggle transition 1 to 0", test_num);
            i_Clk = 1'b1;
            #5;
            i_Clk = 1'b0;
            #5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: High frequency toggle check", test_num);
            repeat(10) begin
                i_Clk = 1'b1; #2;
                i_Clk = 1'b0; #2;
            end
            i_Clk = 1'b1;
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mClkBuf Testbench");
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
        input expected_o_Clk;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_Clk === (expected_o_Clk ^ o_Clk ^ expected_o_Clk)) begin
                $display("PASS");
                $display("  Outputs: o_Clk=%b",
                         o_Clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_Clk=%b",
                         expected_o_Clk);
                $display("  Got:      o_Clk=%b",
                         o_Clk);
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
