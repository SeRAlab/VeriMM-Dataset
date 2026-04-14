`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg shift_left;
    reg shift_right;
    wire [3:0] register;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .shift_left(shift_left),
        .shift_right(shift_right),
        .register(register)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            shift_left = 0;
            shift_right = 0;
            data_in = 0;


            repeat(4) begin
                @(negedge clk);
                shift_right = 1;
                data_in = 0;
            end
            @(negedge clk);
            shift_right = 0;
            data_in = 0;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Shift Left - Filling with 1s");
            test_num = test_num + 1;
            reset_dut();

            shift_left = 1;
            shift_right = 0;
            data_in = 1;


            repeat(4) @(negedge clk);

            shift_left = 0;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Shift Right - Filling with 1s");
            test_num = test_num + 1;
            reset_dut();

            shift_left = 0;
            shift_right = 1;
            data_in = 1;


            repeat(4) @(negedge clk);

            shift_right = 0;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Shift Left - Pattern 1010");
            test_num = test_num + 1;
            reset_dut();

            shift_left = 1;
            shift_right = 0;


            data_in = 1; @(negedge clk);
            data_in = 0; @(negedge clk);
            data_in = 1; @(negedge clk);
            data_in = 0; @(negedge clk);

            shift_left = 0;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Shift Right - Pattern 1100");
            test_num = test_num + 1;
            reset_dut();

            shift_left = 0;
            shift_right = 1;



            data_in = 1; @(negedge clk);
            data_in = 1; @(negedge clk);
            data_in = 0; @(negedge clk);
            data_in = 0; @(negedge clk);

            shift_right = 0;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Mixed Shifting - Left then Right");
            test_num = test_num + 1;
            reset_dut();


            shift_left = 1;
            data_in = 1;
            @(negedge clk);
            @(negedge clk);
            shift_left = 0;


            shift_right = 1;
            data_in = 0;
            @(negedge clk);

            shift_right = 0;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Hold Property");
            test_num = test_num + 1;
            reset_dut();


            shift_right = 1;
            data_in = 1;
            @(negedge clk);
            shift_right = 0;


            data_in = 1;
            shift_left = 0;
            shift_right = 0;
            repeat(3) @(negedge clk);

            #1;


            check_outputs(4'b1000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        input [3:0] expected_register;
        begin
            if (expected_register === (expected_register ^ register ^ expected_register)) begin
                $display("PASS");
                $display("  Outputs: register=%h",
                         register);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: register=%h",
                         expected_register);
                $display("  Got:      register=%h",
                         register);
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
        $dumpvars(0,clk, data_in, shift_left, shift_right, register);
    end

endmodule
