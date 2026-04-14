`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] adr;
    reg clk;
    reg [1:0] din;
    wire [1:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adr(adr),
        .clk(clk),
        .din(din),
        .q(q)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running testcase001 - Address 00");

            adr = 2'b00; din = 2'b00;
            @(negedge clk);


            adr = 2'b00; din = 2'b01;
            @(negedge clk);


            adr = 2'b00; din = 2'b10;
            @(negedge clk);



            `ifdef TEST_2
                #1;

                check_outputs(2'b10);
            `else
                #1;

                check_outputs(2'b01);
            `endif
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running testcase002 - Address 01");

            adr = 2'b01; din = 2'b00;
            @(negedge clk);


            adr = 2'b01; din = 2'b11;
            @(negedge clk);


            adr = 2'b01; din = 2'b01;
            @(negedge clk);

            `ifdef TEST_2
                #1;

                check_outputs(2'b01);
            `else
                #1;

                check_outputs(2'b11);
            `endif
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running testcase003 - Address 10");

            adr = 2'b10; din = 2'b00;
            @(negedge clk);


            adr = 2'b10; din = 2'b10;
            @(negedge clk);


            adr = 2'b10; din = 2'b11;
            @(negedge clk);

            `ifdef TEST_2
                #1;

                check_outputs(2'b11);
            `else
                #1;

                check_outputs(2'b10);
            `endif
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running testcase004 - Address 11");

            adr = 2'b11; din = 2'b00;
            @(negedge clk);


            adr = 2'b11; din = 2'b01;
            @(negedge clk);


            adr = 2'b11; din = 2'b00;
            @(negedge clk);

            `ifdef TEST_2
                #1;

                check_outputs(2'b00);
            `else
                #1;

                check_outputs(2'b01);
            `endif
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
        input [1:0] expected_q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
