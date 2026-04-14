`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] clkselect;
    reg [3:0] inclk;
    wire outclk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clkselect(clkselect),
        .inclk(inclk),
        .outclk(outclk)
    );
    task testcase001;

        begin
            test_num = 1;
            clkselect = 2'b00;
            inclk = 4'b1110;
            #10;
            $display("Test %0d: Select 0, inclk=1110", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            clkselect = 2'b00;
            inclk = 4'b0001;
            #10;
            $display("Test %0d: Select 0, inclk=0001", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            clkselect = 2'b01;
            inclk = 4'b1101;
            #10;
            $display("Test %0d: Select 1, inclk=1101", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            clkselect = 2'b01;
            inclk = 4'b0010;
            #10;
            $display("Test %0d: Select 1, inclk=0010", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            clkselect = 2'b10;
            inclk = 4'b1011;
            #10;
            $display("Test %0d: Select 2, inclk=1011", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            clkselect = 2'b10;
            inclk = 4'b0100;
            #10;
            $display("Test %0d: Select 2, inclk=0100", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            clkselect = 2'b11;
            inclk = 4'b0111;
            #10;
            $display("Test %0d: Select 3, inclk=0111", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            clkselect = 2'b11;
            inclk = 4'b1000;
            #10;
            $display("Test %0d: Select 3, inclk=1000", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            clkselect = 2'b00;
            inclk = 4'b0001;
            #5;
            inclk = 4'b1111;
            #5;
            $display("Test %0d: Isolation test (Select 0, changing other bits)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            inclk = 4'b0010;
            clkselect = 2'b00;
            #5;
            clkselect = 2'b01;
            #5;
            $display("Test %0d: Selection transition (0 -> 1)", test_num);
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
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input expected_outclk;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_outclk === (expected_outclk ^ outclk ^ expected_outclk)) begin
                $display("PASS");
                $display("  Outputs: outclk=%b",
                         outclk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outclk=%b",
                         expected_outclk);
                $display("  Got:      outclk=%b",
                         outclk);
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
