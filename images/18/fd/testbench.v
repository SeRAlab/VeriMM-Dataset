`timescale 1ns/1ps

module flash_memory_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg erase;
    reg program;
    wire stored_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    flash_memory dut (
        .clk(clk),
        .erase(erase),
        .program(program),
        .stored_value(stored_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            erase = 1;
            program = 0;
            @(posedge clk);
            #1;
            erase = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: Basic Erase Operation", test_num);
            reset_dut();

            erase = 1;
            program = 0;
            @(posedge clk);
            #1;
            erase = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: Basic Program Operation", test_num);
            reset_dut();

            erase = 0;
            program = 1;
            @(posedge clk);
            #1;
            program = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: Data Retention", test_num);
            reset_dut();

            program = 1;
            @(posedge clk);
            #1;
            program = 0;

            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %03d: Erase after Program", test_num);
            reset_dut();

            program = 1;
            @(posedge clk);
            #1;

            program = 0;
            erase = 1;
            @(posedge clk);
            #1;
            erase = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %03d: Program after Erase", test_num);
            reset_dut();

            erase = 0;
            program = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %03d: Simultaneous Program and Erase", test_num);
            reset_dut();
            erase = 1;
            program = 1;
            @(posedge clk);
            #1;
            erase = 0;
            program = 0;

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
        $display("flash_memory Testbench");
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
        input expected_stored_value;
        begin
            if (expected_stored_value === (expected_stored_value ^ stored_value ^ expected_stored_value)) begin
                $display("PASS");
                $display("  Outputs: stored_value=%b",
                         stored_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stored_value=%b",
                         expected_stored_value);
                $display("  Got:      stored_value=%b",
                         stored_value);
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
        $dumpvars(0,clk, erase, program, stored_value);
    end

endmodule
