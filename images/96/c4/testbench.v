`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in;
    wire [1:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset and Zero Input", test_num);


            rst = 1;
            in = 0;
            repeat(2) @(posedge clk);
            rst = 0;


            repeat(5) @(posedge clk);

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Impulse Input", test_num);

            rst = 1;
            in = 0;
            @(posedge clk);
            #1 rst = 0;

            in = 4'hF;
            @(posedge clk);
            in = 4'h0;


            repeat(10) @(posedge clk);



            if (out != 0)
                #1;

                check_outputs(out);
            else
                #1;

                check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Constant Step Input", test_num);

            rst = 1;
            in = 0;
            @(posedge clk);
            #1 rst = 0;

            in = 4'h5;
            repeat(20) @(posedge clk);



            #1;




            check_outputs(out);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Input Value", test_num);

            rst = 1;
            in = 0;
            @(posedge clk);
            #1 rst = 0;

            in = 4'hF;
            repeat(15) @(posedge clk);

            #1;


            check_outputs(out);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Input", test_num);

            rst = 1;
            @(posedge clk);
            #1 rst = 0;

            repeat(5) begin
                in = 4'hA; @(posedge clk);
                in = 4'h5; @(posedge clk);
            end

            repeat(5) @(posedge clk);
            #1;

            check_outputs(out);
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
        input [1:0] expected_out;
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
