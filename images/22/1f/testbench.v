`timescale 1ns/1ps

module frequency_divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] control;
    reg reset;
    wire divided_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    frequency_divider dut (
        .clk(clk),
        .control(control),
        .reset(reset),
        .divided_clk(divided_clk)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            control = 2'b00;
            #15;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Testing Divide by 2", test_num);
            reset_dut();
            control = 2'b00;
            repeat(1) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Testing Divide by 4 - Half cycle", test_num);
            reset_dut();
            control = 2'b01;
            repeat(1) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Testing Divide by 4 - Full cycle", test_num);
            reset_dut();
            control = 2'b01;
            repeat(3) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Testing Divide by 8 - Half cycle", test_num);
            reset_dut();
            control = 2'b10;
            repeat(3) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Testing Divide by 8 - Full cycle", test_num);
            reset_dut();
            control = 2'b10;
            repeat(7) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Testing Reset mid-operation", test_num);
            reset_dut();
            control = 2'b00;
            @(posedge clk);
            reset = 1;
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Testing Control Signal Switch", test_num);
            reset_dut();
            control = 2'b00;
            repeat(2) @(posedge clk);
            control = 2'b10;
            repeat(8) @(posedge clk);
            #2;
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
        $display("frequency_divider Testbench");
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
        input expected_divided_clk;
        begin
            if (expected_divided_clk === (expected_divided_clk ^ divided_clk ^ expected_divided_clk)) begin
                $display("PASS");
                $display("  Outputs: divided_clk=%b",
                         divided_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: divided_clk=%b",
                         expected_divided_clk);
                $display("  Got:      divided_clk=%b",
                         divided_clk);
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
        $dumpvars(0,clk, control, reset, divided_clk);
    end

endmodule
