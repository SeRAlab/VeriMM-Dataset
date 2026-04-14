`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg sys_clk;
    reg sys_rst;
    wire data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .sys_clk(sys_clk),
        .sys_rst(sys_rst),
        .data_o(data_o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Active State", test_num);

            sys_clk = 0;
            sys_rst = 1;
            #20;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Clock Toggling with Reset Active", test_num);
            sys_rst = 1;

            repeat(10) begin
                #5 sys_clk = ~sys_clk;
            end
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Normal Operation (Reset De-asserted)", test_num);

            sys_rst = 1;
            sys_clk = 0;
            #10;

            sys_rst = 0;
            #10;

            repeat(20) begin
                #5 sys_clk = ~sys_clk;
            end
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Asynchronous Input Transitions", test_num);

            sys_rst = 1;
            #10;
            sys_rst = 0;
            #10;

            sys_clk = 1; sys_rst = 1; #7;
            sys_clk = 0; sys_rst = 0; #3;
            sys_clk = 1; sys_rst = 0; #12;
            sys_clk = 0; sys_rst = 1; #5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Long Duration Static State", test_num);

            sys_rst = 1;
            #10;
            sys_rst = 0;
            sys_clk = 0;

            #500;
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
        input expected_data_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%b",
                         data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%b",
                         expected_data_o);
                $display("  Got:      data_o=%b",
                         data_o);
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
