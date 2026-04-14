`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg data_in;
    reg reset;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros Sequence", test_num);


            reset = 1;
            data_in = 0;
            @(posedge clk);
            #1 reset = 0;


            repeat (20) begin
                data_in = 0;
                @(posedge clk);
            end


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Encoded Pattern", test_num);

            reset = 1;
            @(posedge clk);
            #1 reset = 0;



            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);


            repeat (30) begin
                data_in = 0;
                @(posedge clk);
            end



            #1;




            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Error Correction (Single Bit Flip)", test_num);

            reset = 1;
            @(posedge clk);
            #1 reset = 0;



            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);


            repeat (32) begin
                data_in = 0;
                @(posedge clk);
            end



            #1;




            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Data Pattern", test_num);

            reset = 1;
            @(posedge clk);
            #1 reset = 0;


            repeat(5) begin
                data_in = 1; @(posedge clk);
                data_in = 1; @(posedge clk);
                data_in = 0; @(posedge clk);
                data_in = 0; @(posedge clk);
            end


            repeat (20) begin
                data_in = 0;
                @(posedge clk);
            end

            #1;


            check_outputs(1'b0);
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
        input expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b",
                         expected_data_out);
                $display("  Got:      data_out=%b",
                         data_out);
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
