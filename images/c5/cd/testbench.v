`timescale 1ns/1ps

module inverted_input_buffer_tb;

    // Testbench signals (combinational circuit)
    reg i;
    reg ibar;
    wire o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    inverted_input_buffer dut (
        .i(i),
        .ibar(ibar),
        .o(o)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Basic Logic Low (i=0, ibar=1)", test_num);
            i = 1'b0;
            ibar = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Basic Logic High (i=1, ibar=0)", test_num);
            i = 1'b1;
            ibar = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Ignore ibar (i=0, ibar=0)", test_num);
            i = 1'b0;
            ibar = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Ignore ibar (i=1, ibar=1)", test_num);
            i = 1'b1;
            ibar = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Transition from High to Low", test_num);
            i = 1'b1; ibar = 1'b0;
            #5;
            i = 1'b0; ibar = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Transition from Low to High", test_num);
            i = 1'b0; ibar = 1'b1;
            #5;
            i = 1'b1; ibar = 1'b0;
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
        $display("inverted_input_buffer Testbench");
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
        input expected_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%b",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%b",
                         expected_o);
                $display("  Got:      o=%b",
                         o);
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
