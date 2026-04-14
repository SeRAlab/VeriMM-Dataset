`timescale 1ns/1ps

module clock_gating_ff_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg data_in;
    reg enable;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    clock_gating_ff dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .data_out(data_out)
    );
    task reset_to_zero;

    begin
        clk = 0;
        enable = 1;
        data_in = 0;
        #10 clk = 1; #10 clk = 0;
        enable = 0;
        #10;
    end
        endtask

    task reset_to_one;

    begin
        clk = 0;
        enable = 1;
        data_in = 1;
        #10 clk = 1; #10 clk = 0;
        enable = 0;
        #10;
    end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Load Data '1' when Enable is High", test_num);

        reset_to_zero();


        enable = 1;
        data_in = 1;
        #10;
        clk = 1;
        #10;
        clk = 0;


        #1;



        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Hold Data '1' when Enable is Low (Clock Gating)", test_num);

        reset_to_one();


        enable = 0;
        data_in = 0;
        #10;
        clk = 1;
        #10;
        clk = 0;


        #1;



        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Load Data '0' when Enable is High", test_num);

        reset_to_one();


        enable = 1;
        data_in = 0;
        #10;
        clk = 1;
        #10;
        clk = 0;


        #1;



        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Hold Data '0' when Enable is Low", test_num);

        reset_to_zero();


        enable = 0;
        data_in = 1;
        #10;
        clk = 1;
        #10;
        clk = 0;


        #1;



        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Data Change while Clock is High (No Pulse)", test_num);

        reset_to_zero();


        enable = 1;
        clk = 1;
        #10;
        data_in = 1;
        #10;


        #1;



        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Enable Toggle Timing", test_num);

        reset_to_zero();


        data_in = 1;
        enable = 0;
        #5;
        enable = 1;
        #5;
        clk = 1;
        #10;
        clk = 0;


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
        $display("clock_gating_ff Testbench");
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
