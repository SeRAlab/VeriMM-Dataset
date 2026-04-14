`timescale 1ns/1ps

module rnn_cell_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] input_data;
    reg [1:0] prev_h;
    wire [1:0] next_h;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_cell dut (
        .input_data(input_data),
        .prev_h(prev_h),
        .next_h(next_h)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: input_data=0, prev_h=0", test_num);
            input_data = 2'b00;
            prev_h = 2'b00;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: input_data=1, prev_h=1", test_num);
            input_data = 2'b01;
            prev_h = 2'b01;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: input_data=2, prev_h=1", test_num);
            input_data = 2'b10;
            prev_h = 2'b01;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: input_data=3, prev_h=1", test_num);
            input_data = 2'b11;
            prev_h = 2'b01;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: input_data=2, prev_h=2", test_num);
            input_data = 2'b10;
            prev_h = 2'b10;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: input_data=3, prev_h=2", test_num);
            input_data = 2'b11;
            prev_h = 2'b10;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: input_data=3, prev_h=3", test_num);
            input_data = 2'b11;
            prev_h = 2'b11;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: input_data=0, prev_h=3", test_num);
            input_data = 2'b00;
            prev_h = 2'b11;
            #1;

            check_outputs(2'b11);
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
        input [1:0] expected_next_h;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_next_h === (expected_next_h ^ next_h ^ expected_next_h)) begin
                $display("PASS");
                $display("  Outputs: next_h=%h",
                         next_h);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_h=%h",
                         expected_next_h);
                $display("  Got:      next_h=%h",
                         next_h);
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
