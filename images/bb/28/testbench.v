`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg b;
    reg [99:0] input_vector;
    wire [7:0] final_output;
    wire [199:0] multiplied_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .input_vector(input_vector),
        .final_output(final_output),
        .multiplied_output(multiplied_output)
    );

    // Clock generation (10ns period)
    initial begin
        a = 0;
        forever #5 a = ~a;
    end

        task reset_dut;

        begin
            b = 0;
            input_vector = 0;

            repeat(5) @(posedge a);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Running Testcase %0d: All Zeros Input", test_num);
            @(negedge a);
            b = 0;
            input_vector = 100'h0;
            @(posedge a);
            #2;


            #1;



            check_outputs(8'h00, {100'h0, 100'hFFFFFFFFFFFFFFFFFFFFFFFFF});
        end
        endtask

    task testcase002;

        begin
            test_num = 2;

            $display("Running Testcase %0d: Single Bit Shift (b=1, iv=0)", test_num);
            @(negedge a);
            b = 1;
            input_vector = 100'h0;
            @(posedge a);
            #2;



            #1;




            check_outputs(8'h00, 200'h1FFFFFFFFFFFFFFFFFFFFFFFE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Running Testcase %0d: NAND Logic Check (iv=all 1s, b=1)", test_num);
            @(negedge a);
            input_vector = {100{1'b1}};
            b = 1;
            @(posedge a);
            #2;

            #1;


            check_outputs(8'h00, {100'h0, 100'hFFFFFFFFFFFFFFFFFFFFFFFFE});
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();
            $display("Running Testcase %0d: Final Output Accumulation", test_num);
            @(negedge a);
            input_vector = 100'h0;
            b = 1;



            repeat(110) @(posedge a);
            #2;




            if (final_output > 8'h00) begin
                $display("PASS: final_output reached %h", final_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: final_output still zero at %h", final_output);
                fail_count = fail_count + 1;
            end
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
        input [7:0] expected_final_output;
        input [199:0] expected_multiplied_output;
        begin
            if (expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_multiplied_output === (expected_multiplied_output ^ multiplied_output ^ expected_multiplied_output)) begin
                $display("PASS");
                $display("  Outputs: final_output=%h, multiplied_output=%h",
                         final_output, multiplied_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_output=%h, multiplied_output=%h",
                         expected_final_output, expected_multiplied_output);
                $display("  Got:      final_output=%h, multiplied_output=%h",
                         final_output, multiplied_output);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,a, b, input_vector, final_output, multiplied_output);
    end

endmodule
