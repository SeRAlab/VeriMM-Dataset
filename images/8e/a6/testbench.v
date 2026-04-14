`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [31:0] in;
    reg rst;
    wire [5:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .rst(rst),
        .count(count)
    );
    task perform_reset;

        begin
            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Check", test_num);
            in = 32'hFFFFFFFF;
            perform_reset();
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Cycle Accumulation (Input 1 bit)", test_num);
            perform_reset();
            in = 32'h00000001;
            @(posedge clk);

            #1;


            check_outputs(6'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Cycles Accumulation", test_num);
            perform_reset();


            in = 32'h00000003;
            @(posedge clk);



            in = 32'h00000007;
            @(posedge clk);


            #1;



            check_outputs(6'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All ones in 32-bit input", test_num);
            perform_reset();
            in = 32'hFFFFFFFF;
            @(posedge clk);

            #1;


            check_outputs(6'd32);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Cumulative wrap-around check", test_num);
            perform_reset();


            in = 32'hFFFFFFFF;
            @(posedge clk);




            in = 32'hFFFFFFFF;
            @(posedge clk);

            #1;


            check_outputs(6'd32);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequence with zeros", test_num);
            perform_reset();

            in = 32'h0000000F;
            @(posedge clk);

            in = 32'h00000000;
            @(posedge clk);

            in = 32'h00000000;
            @(posedge clk);

            #1;


            check_outputs(6'd16);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complex mixed pattern", test_num);
            perform_reset();

            in = 32'h55555555;
            @(posedge clk);

            in = 32'h00000001;
            @(posedge clk);

            in = 32'h00000003;
            @(posedge clk);

            #1;


            check_outputs(6'd4);
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
        input [5:0] expected_count;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
