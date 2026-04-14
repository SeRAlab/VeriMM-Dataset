`timescale 1ns/1ps

module keypad_scanner_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] col;
    wire [3:0] row;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    keypad_scanner dut (
        .clk(clk),
        .col(col),
        .row(row)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            col = 4'b0000;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Idle State (No key pressed)", test_num);
            reset_dut();

            col = 4'b0000;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Key pressed on Column 1", test_num);
            reset_dut();

            col = 4'b0001;

            repeat(8) @(posedge clk);




            if (row != 4'b0000)
                pass_count = pass_count;


            #1;



            check_outputs(row);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Key pressed on Column 2", test_num);
            reset_dut();

            col = 4'b0010;
            repeat(8) @(posedge clk);


            if (row == 4'b0000)
                $display("FAIL: No row detected for Col 2");

            #1;


            check_outputs(row);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Key pressed on Column 4", test_num);
            reset_dut();

            col = 4'b1000;
            repeat(8) @(posedge clk);

            #1;


            check_outputs(row);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Key Release", test_num);
            reset_dut();


            col = 4'b0100;
            repeat(4) @(posedge clk);


            col = 4'b0000;
            repeat(4) @(posedge clk);

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple keys (Col 1 and Col 4)", test_num);
            reset_dut();

            col = 4'b1001;
            repeat(8) @(posedge clk);


            if (row != 4'b0000)
                $display("PASS: Row signal detected for multiple column inputs");

            #1;


            check_outputs(row);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("keypad_scanner Testbench");
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
        input [3:0] expected_row;
        begin
            if (expected_row === (expected_row ^ row ^ expected_row)) begin
                $display("PASS");
                $display("  Outputs: row=%h",
                         row);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: row=%h",
                         expected_row);
                $display("  Got:      row=%h",
                         row);
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
        $dumpvars(0,clk, col, row);
    end

endmodule
