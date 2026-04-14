`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] mode;
    reg [2:0] pin_num;
    reg pin_value;
    wire pin_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .mode(mode),
        .pin_num(pin_num),
        .pin_value(pin_value),
        .pin_output(pin_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            mode = 2'b00;
            pin_num = 3'b000;
            pin_value = 1'b0;
            repeat (2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Write 1 to Pin 0 and Read");
            test_num = test_num + 1;
            reset_dut();


            @(negedge clk);
            mode = 2'b01;
            pin_num = 3'd0;
            pin_value = 1'b1;


            @(negedge clk);
            mode = 2'b10;
            pin_num = 3'd0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Write 1 to Pin 7 and Read");
            test_num = test_num + 1;
            reset_dut();


            @(negedge clk);
            mode = 2'b01;
            pin_num = 3'd7;
            pin_value = 1'b1;


            @(negedge clk);
            mode = 2'b10;
            pin_num = 3'd7;

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Read Pin 4 after reset (Initial State)");
            test_num = test_num + 1;
            reset_dut();


            @(negedge clk);
            mode = 2'b10;
            pin_num = 3'd4;

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Overwrite Pin 2 (1 then 0)");
            test_num = test_num + 1;
            reset_dut();


            @(negedge clk);
            mode = 2'b01; pin_num = 3'd2; pin_value = 1'b1;

            @(negedge clk);
            mode = 2'b01; pin_num = 3'd2; pin_value = 1'b0;


            @(negedge clk);
            mode = 2'b10; pin_num = 3'd2;

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Verify Independence (Write Pin 1, Read Pin 5)");
            test_num = test_num + 1;
            reset_dut();


            @(negedge clk);
            mode = 2'b01; pin_num = 3'd1; pin_value = 1'b1;


            @(negedge clk);
            mode = 2'b10; pin_num = 3'd5;

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Multiple writes (Pin 3 and Pin 6)");
            test_num = test_num + 1;
            reset_dut();


            @(negedge clk);
            mode = 2'b01; pin_num = 3'd3; pin_value = 1'b1;

            @(negedge clk);
            mode = 2'b01; pin_num = 3'd6; pin_value = 1'b1;


            @(negedge clk);
            mode = 2'b10; pin_num = 3'd3;

            @(posedge clk);
            #2;
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
        $display("gpio_controller Testbench");
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
        input expected_pin_output;
        begin
            if (expected_pin_output === (expected_pin_output ^ pin_output ^ expected_pin_output)) begin
                $display("PASS");
                $display("  Outputs: pin_output=%b",
                         pin_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pin_output=%b",
                         expected_pin_output);
                $display("  Got:      pin_output=%b",
                         pin_output);
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
        $dumpvars(0,clk, mode, pin_num, pin_value, pin_output);
    end

endmodule
